import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_chatsen_irc/api/chatsen_static/chatsen_static.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '/IRCMessage.dart';
import '/WebSockets/AbstractWebSocket.dart';

abstract class Listener {
  void onConnectionStateChange(Connection connection, ConnectionState state);
  void onChannelStateChange(Channel channel, ChannelState state);
  void onMessage(Channel? channel, Message message);
  void onHistoryLoaded(Channel channel);
  void onWhisper(Channel channel, Message message);
}

// TODO: Rework with consideration for emote sets and link to emote if available, maybe even owner and whatnot
class Emote {
  final String? name;
  final String? id;
  final String? provider;
  final String? set;
  final List<String?>? mipmap;
  final bool zeroWidth; // Flag set/Bitfield would be better, for chatsen2 Copesen
  final String? alt;

  Emote({
    this.name,
    this.id,
    this.provider,
    this.set,
    this.mipmap,
    this.zeroWidth = false,
    this.alt,
  });
}

enum MessageTokenType {
  Text,
  Link,
  Image,
  Video,
  Emote,
  EmoteStack,
  User,
}

class Badge {
  final String? tag;
  final String? name;
  final String? id;
  final List<String?>? mipmap;
  final String? title;
  final String? description;
  final String? color;
  final bool cache;

  Badge({
    this.tag,
    this.name,
    this.id,
    this.mipmap,
    this.title,
    this.description,
    this.color,
    this.cache = true,
  });

  Badge.fromJson(String? typename, String? typeid, Map<String, dynamic> json)
      : tag = '$typename/$typeid',
        name = typename,
        id = typeid,
        mipmap = [
          json['image_url_1x'],
          json['image_url_2x'],
          json['image_url_4x'],
        ],
        title = json['title'],
        description = json['description'],
        color = null,
        cache = true;
}

class TwitchEmote {
  final String? id;
  final int? startPosition;
  final int? endPosition;

  TwitchEmote({
    this.id,
    this.startPosition,
    this.endPosition,
  });
}

class MessageToken {
  MessageTokenType type;
  dynamic data;

  MessageToken.text(String text)
      : type = MessageTokenType.Text,
        data = text;

  MessageToken.link(String url)
      : type = MessageTokenType.Link,
        data = url;

  MessageToken.image(String url)
      : type = MessageTokenType.Image,
        data = url;

  MessageToken.video(String url)
      : type = MessageTokenType.Video,
        data = url;

  MessageToken.emote(Emote emote)
      : type = MessageTokenType.Emote,
        data = emote;

  MessageToken.emoteStack(List<Emote> emotes)
      : type = MessageTokenType.EmoteStack,
        data = emotes;

  MessageToken.user(User user)
      : type = MessageTokenType.User,
        data = user;
}

class Credentials {
  final int? id;
  final String login;
  final String? clientId;
  final String? token;

  const Credentials({
    this.id,
    this.login = 'justinfan64537',
    this.clientId,
    this.token,
  });
}

class User {
  String? login;
  String? displayName;
  int? id;
  String? color;

  User({
    this.login,
    this.displayName,
    this.id,
    this.color,
  });
}

class Message {
  Channel? channel;

  User? user;
  String? id;
  String? body;

  bool action = false;
  bool mention = false;
  bool blocked = false;
  bool history = false; // TODO: Use a bitfield
  bool deleted = false;

  List<Badge> badges = [];
  List<MessageToken> tokens = [];
  List<TwitchEmote> twitchEmotes = [];

  DateTime? dateTime;

  Message({
    String tagBadges = '',
    String tagEmotes = '',
    this.channel,
    this.user,
    this.id,
    this.body,
    this.dateTime,
    this.history = false,
  }) {
    // replace U+200D (ZERO WIDTH JOINER) with U+E0002
    // alternative regex for replacement: (?<!\U000E0002)\U000E0002
    var replacement = String.fromCharCodes(Runes('\u{e0002}'));
    var zeroWidthJoiner = String.fromCharCodes(Runes('\u{200d}'));
    body = body?.replaceAll(replacement, zeroWidthJoiner);

    if (body!.contains(RegExp('ACTION .*'))) action = true;
    if (action) body = body!.substring('ACTION '.length, body!.length - 1);

    // body = body!.replaceAll(utf8.decode([0xF3, 0xA0, 0x80, 0x80]), '');

    for (var tagBadge in tagBadges.split(',')) {
      var badge = channel?.badges?.firstWhere((badge) => badge!.tag == tagBadge, orElse: () => channel!.client!.badges.firstWhereOrNull((badge) => badge.tag == tagBadge));
      if (badge != null) badges.add(badge);
    }

    for (var tagEmote in tagEmotes.split('/')) {
      var tagEmoteDetails = tagEmote.split(':');
      if (tagEmoteDetails.length < 2) continue;
      var tagEmoteId = tagEmoteDetails.first;
      var tagEmotePositions = tagEmoteDetails.last.split(',');
      for (var tagEmotePosition in tagEmotePositions.map((tagEmotePosition) => tagEmotePosition.split('-'))) {
        twitchEmotes.add(
          TwitchEmote(
            id: tagEmoteId,
            startPosition: int.parse(tagEmotePosition.first),
            endPosition: int.parse(tagEmotePosition.last),
          ),
        );
      }
    }

    twitchEmotes.sort((item, item2) => item2.startPosition!.compareTo(item.startPosition!));

    try {
      tokens = tokenize(body!);
    } catch (e) {
      print('$e: $body');
    }

    dateTime = dateTime ?? DateTime.now();
  }

  // TOOD: Needs a rework, maybe use "Type is Type" instead of wrappers with enum
  List<MessageToken> tokenize(String body) {
    const zeroWidthEmotes = <String>[
      'SoSnowy',
      'IceCold',
      'SantaHat',
      'TopHat',
      'ReinDeer',
      'CandyCane',
      'cvMask',
      'cvHazmat',
    ];

    var tokens = <MessageToken>[];

    var runes = body.runes.toList();
    for (var twitchEmote in twitchEmotes) {
      runes.replaceRange(twitchEmote.startPosition!, twitchEmote.endPosition! + 1, utf8.encode(' ${twitchEmote.id}|${String.fromCharCodes(runes.getRange(twitchEmote.startPosition!, twitchEmote.endPosition! + 1))} '));
    }

    var runeBody = String.fromCharCodes(runes).replaceAll(utf8.decode([0xF3, 0xA0, 0x80, 0x80]), '');

    var splits = runeBody.split(' ').where((split) => split.isNotEmpty);
    mention = splits.any(
      (split) => (split.toLowerCase() == '${channel?.receiver?.credentials?.login.toLowerCase()}' || split.toLowerCase() == '@${channel?.receiver?.credentials?.login.toLowerCase()}' || split.toLowerCase() == '${channel?.receiver?.credentials?.login.toLowerCase()},' || split.toLowerCase() == '@${channel?.receiver?.credentials?.login.toLowerCase()},'),
    );

    for (var messageSplit in splits) {
      var client = channel?.transmitter?.client;

      var twitchEmote;
      if (messageSplit.startsWith('')) {
        var emoteData = messageSplit.substring(1).split('|');

        twitchEmote = Emote(
          id: emoteData.first,
          name: emoteData.last,
          provider: 'Twitch',
          mipmap: [
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/1.0',
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/2.0',
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/3.0',
            // 'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/4.0',
          ],
        );
      }

      var channelEmote = channel?.emotes.firstWhereOrNull((emote) => (emote.alt ?? emote.name) == messageSplit);
      var globalEmote = client?.emotes.firstWhereOrNull((emote) => (emote.alt ?? emote.name) == messageSplit);
      var emojiEmote = client?.emojis.firstWhereOrNull((emote) => (emote.alt ?? emote.name) == messageSplit);
      var emote = twitchEmote ?? channelEmote ?? globalEmote ?? emojiEmote;
      var lowSplit = messageSplit.toLowerCase();

      if (lowSplit.startsWith('http://') || lowSplit.startsWith('https://')) {
        if (lowSplit.endsWith('.png') || lowSplit.endsWith('.jpg') || lowSplit.endsWith('.jpeg') || lowSplit.endsWith('.apng') || lowSplit.endsWith('.gif') || lowSplit.endsWith('.webp')) {
          tokens.add(MessageToken.image(messageSplit));
        } else {
          tokens.add(MessageToken.link(messageSplit));
        }
      } else if (emote != null) {
        bool isZeroWidth = (zeroWidthEmotes.contains(emote.name) || emote.zeroWidth);
        if (tokens.isNotEmpty && tokens.last.type == MessageTokenType.Emote && isZeroWidth) {
          tokens.last = MessageToken.emoteStack([tokens.last.data as Emote, emote]);
        } else if (tokens.isNotEmpty && tokens.last.type == MessageTokenType.EmoteStack && isZeroWidth) {
          (tokens.last.data as List<Emote>).add(emote);
        } else {
          tokens.add(MessageToken.emote(emote));
        }
      } else {
        if (tokens.isNotEmpty && tokens.last.type == MessageTokenType.Text) {
          tokens.last.data += ' $messageSplit';
        } else {
          tokens.add(MessageToken.text(messageSplit));
        }
      }
    }
    return tokens;
  }
}

enum ChannelState {
  Disconnected,
  Connecting,
  Connected,
  Suspended,
  Banned,
}

class Channel {
  Client? client;
  Connection? receiver;
  Connection? transmitter;
  String? name;
  int? id;

  List<Message> messages = [];
  List<Emote> emotes = [];
  List<Badge?> badges = [];
  Map<String, List<String>> users = {};

  var state = ChannelState.Disconnected;
  set stateChanger(ChannelState newState) {
    if (state == newState) {
      return;
    }

    state = newState;

    client!.listeners.forEach((listener) => listener.onChannelStateChange(this, state));
  }

  Future<void> loadHistory() async {
    if (!client!.useRecentMessages) {
      var chatMessage = Message(
        channel: this,
        body: 'Chat history is disabled because you have opted-out. Head over to Chatsen\'s settings if you wish to turn it on.',
        dateTime: DateTime.now(),
      );

      messages.add(chatMessage);
      if (messages.length > 1000) messages.removeRange(0, messages.length - 1000);
      client!.listeners.forEach((listener) => listener.onHistoryLoaded(this));
      return;
    }

    // https://recent-messages.robotty.de/api/v2/recent-messages/
    var response = await http.get(Uri.parse('https://recent-messages.robotty.de/api/v2/recent-messages/${name!.substring(1)}'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    for (var raw in jsonResponse['messages'] ?? []) {
      var message = IRCMessage.fromData(raw);
      if (message?.command != 'PRIVMSG') {
        // print(raw);
        continue;
      }

      if (message!.parameters.length > 2) {
        // print(message.parameters[1]);
        message.parameters = [
          message.parameters[0],
          message.parameters.sublist(1).join(':'),
        ];
      }

      var chatMessage = Message(
        channel: this,
        history: true,
        user: User(
          login: message.prefix.split('!').first.toLowerCase(),
          displayName: message.tags['display-name'],
          id: int.tryParse(message.tags['user-id'] ?? '0'),
          color: (message.tags['color'] == null || message.tags['color'].trim().isEmpty ? null : message.tags['color'].substring(1)),
        ),
        id: message.tags['id'],
        body: message.parameters[1],
        tagBadges: message.tags['badges'],
        tagEmotes: message.tags['emotes'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.tags['tmi-sent-ts']) ?? int.tryParse(message.tags['rm-received-ts']) ?? 0),
      );

      if (messages.none((element) => element.id == chatMessage.id)) messages.add(chatMessage);
      if (messages.length > 1000) messages.removeRange(0, messages.length - 1000);
    }

    client!.listeners.forEach((listener) => listener.onHistoryLoaded(this));
  }

  // TODO: Rework this
  Future<dynamic> updateUsers() async {
    // var userListQuery = await GQL.request('''
    //       query {
    //         channel(id: "$id") {
    //           chatters {
    //             staff {
    //               login
    //             }
    //             broadcasters {
    //               login
    //             }
    //             moderators {
    //               login
    //             }
    //             vips {
    //               login
    //             }
    //             viewers {
    //               login
    //             }
    //           }
    //         }
    //       }
    //     ''');

    // users = (userListQuery['data']['channel']['chatters'] as Map<String, dynamic>).map(
    //   (key, chatterList) => MapEntry<String, List<String>>(
    //     key,
    //     List<String>.from(
    //       chatterList.map(
    //         (chatter) => chatter['login'],
    //       ),
    //     ),
    //   ),
    // );

    // return users;
    // var response = await http.get(Uri.parse('http://tmi.twitch.tv/group/user/${name!.substring(1)}/chatters'));
    // var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    // users = Map<String, List<String>>.from(jsonResponse['chatters'].map((k, v) => MapEntry(k, List<String>.from(v))));

    // return users;

    users = {};

    try {
      final response = await http.get(Uri.parse('https://api.chatsen.app/saikin/channel/users/${name!.substring(1)}'));
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      users = {
        'users': [
          for (final userData in responseJson.entries) userData.key as String,
        ],
      };
    } catch (e) {}
    return users;
  }

  // TODO: Rework this
  Future<void> updateBadges() async {
    badges.clear();

    try {
      var request = await http.get(
        Uri.parse('https://api.twitch.tv/helix/chat/badges?broadcaster_id=$id'), // https://badges.twitch.tv/v1/badges/channels/$id/display?language=en
        headers: {
          'Client-ID': client!.credentials.clientId!,
          'Authorization': 'Bearer ${client!.credentials.token}',
        },
      );
      var jsonRequest = jsonDecode(request.body);

      for (var categories in jsonRequest['data']) {
        for (var badgeData in categories['versions']) {
          badges.add(
            Badge.fromJson(
              categories['set_id'],
              badgeData['id'],
              badgeData,
            ),
          );
        }
      }
    } catch (e) {
      print('Couldn\'t load Twitch badges for channel $id');
    }
  }

  // TODO: Rework this
  Future<void> updateEmotes() async {
    emotes.clear();

    try {
      var emotesRequest = await http.get(Uri.parse('https://api.frankerfacez.com/v1/room/id/$id'));
      var jsonRequest = jsonDecode(emotesRequest.body);

      for (var emoteSetEntry in jsonRequest['sets'].entries) {
        var emoteSet = emoteSetEntry.value;
        for (var emoteData in emoteSet['emoticons']) {
          var emote = Emote(
            name: emoteData['name'],
            // id: emoteData['id'], // TODO: Fix implementation
            provider: 'FFZ',
            mipmap: [
              for (var url in emoteData['urls'].values) url.startsWith('http') ? url : 'https:$url',
            ],
          );

          emotes.add(emote);
        }
      }
    } catch (e) {
      print("Couldn't fetch FFZ emotes");
    }

    try {
      var emotesRequest = await http.get(Uri.parse('https://api.betterttv.net/3/cached/users/twitch/$id'));
      var jsonRequest = jsonDecode(emotesRequest.body);

      for (var emoteData in ((jsonRequest['sharedEmotes'] ?? []) + (jsonRequest['channelEmotes'] ?? []))) {
        var emote = Emote(
          name: emoteData['code'],
          id: emoteData['id'],
          provider: 'BTTV',
          mipmap: [
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/1x',
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/2x',
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/3x',
            // 'https://cdn.betterttv.net/emote/${emoteData["id"]}/4x',
          ],
        );

        emotes.add(emote);
      }
    } catch (e) {
      print("Couldn't fetch BTTV emotes");
    }

    try {
      // var data = await GQL.request7('''
      //   query {
      //     user(id: "${name!.substring(1).toLowerCase()}") {
      //       emotes {
      //         id
      //         name
      //         urls
      //         provider
      //         visibility
      //       }
      //     }
      //   }
      // ''');

      final response = await http.get(Uri.parse('https://7tv.io/v3/users/twitch/$id'));
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      for (var emoteData in responseJson['emote_set']['emotes'] ?? responseJson['emote_set']['emote']) {
        final emoteUrls = List<dynamic>.from(emoteData['data']['host']['files']).where((x) => x['format'].toUpperCase() == 'WEBP');
        if (emoteUrls.isEmpty) {
          continue;
        }

        var emote = Emote(
          name: emoteData['name'],
          id: emoteData['id'],
          provider: '7TV',
          mipmap: [
            for (var url in emoteUrls) 'https:${emoteData['data']['host']['url']}/${url['name']}',
          ],
          zeroWidth: (emoteData['data']['flags'] & (1 << 8)) == (1 << 8),
        );

        emotes.add(emote);
      }
    } catch (e) {
      print("Couldn't fetch 7TV emotes");
    }
  }

  Channel({
    this.client,
    this.receiver,
    this.transmitter,
    this.name,
    this.id,
  }) {
    client!.listeners.forEach((listener) => listener.onChannelStateChange(this, state));
  }

  void send(String message, {bool action = false}) async {
    // TODO: Setup buckets per account
    // TODO: Handle whispers

    var replacement = String.fromCharCodes(Runes('\u{e0002}'));
    var zeroWidthJoiner = String.fromCharCodes(Runes('\u{200d}'));
    message = message.replaceAll(zeroWidthJoiner, replacement);

    if (action) return send('ACTION $message');

    if (receiver == transmitter) {
      transmitter?.send('PRIVMSG #${transmitter!.credentials!.login.toLowerCase()} :/w $name $message');
      var chatMessage = Message(
        channel: this,
        user: User(
          login: transmitter!.credentials!.login.toLowerCase(),
          displayName: transmitter!.credentials!.login,
          id: transmitter!.credentials!.id,
          color: '777777',
          // color: (message.tags['color'] == null || message.tags['color'].trim().isEmpty ? null : message.tags['color'].substring(1)),
        ),
        id: null,
        body: message,
        dateTime: DateTime.now(),
      );

      messages.add(chatMessage);
      client!.listeners.forEach((listener) => listener.onWhisper(this, chatMessage));
    } else {
      var lastMessageByTransmitter = messages.lastWhereOrNull((element) => element.user?.id == transmitter!.credentials!.id);
      transmitter?.send('PRIVMSG $name :$message${(lastMessageByTransmitter?.body == message) ? ' ${utf8.decode([0xF3, 0xA0, 0x80, 0x80])}' : ''}');
    }
  }
}

enum ConnectionState {
  Disconnected,
  AuthenticationError,
  SocketError,
  SocketTerminated,
  Reconnecting,
  Connected,
}

class Connection {
  Client? client;
  bool transmission;
  Credentials? credentials;

  List<String?> channelsToPart = [];

  WebSocketChannel? webSocketChannel;
  StreamSubscription? streamSubscription;

  String get name => '${credentials!.login}@${transmission ? 'tx' : 'rx'}';
  Iterable<Channel> get channels => client!.channels.where((channel) => channel.receiver == this);
  List<Channel?> whispers = [];

  var state = ConnectionState.Disconnected;
  set stateChanger(ConnectionState newState) {
    if (state == newState) {
      return;
    }

    state = newState;

    if (state != ConnectionState.Connected) {
      channelsToPart.clear();
      channels.forEach((channel) => channel.stateChanger = ChannelState.Disconnected);
    }

    client!.listeners.forEach((listener) => listener.onConnectionStateChange(this, state));
  }

  List<Emote> emotes = [];

  Future<void> updateUserEmotes({
    List<String> emoteSets = const [],
  }) async {
    if (credentials == null || credentials!.token == null || credentials!.clientId == null || credentials!.id == null) {
      emotes.clear();
      return;
    }

    if (emoteSets.isEmpty) {
      emotes.clear();
      // This is legacy af and will be deprecated
      var emotesRequest = await http.get(
        Uri.parse('https://api.twitch.tv/kraken/users/${credentials!.id}/emotes'),
        headers: {
          'Client-ID': credentials!.clientId!,
          'Accept': 'application/vnd.twitchtv.v5+json',
          'Authorization': 'OAuth ${credentials!.token}',
        },
      );

      var jsonRequest = jsonDecode(emotesRequest.body);

      for (var emoticonSet in jsonRequest['emoticon_sets'].entries) {
        for (var emoteData in emoticonSet.value) {
          emotes.add(
            Emote(
              name: emoteData['code'],
              id: emoteData['id'].toString(),
              provider: 'Twitch',
              mipmap: [
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/1.0',
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/2.0',
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/3.0',
                // 'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/4.0',
              ],
            ),
          );
        }
      }
    } else {
      var newEmotes = <Emote>[];
      const maxSets = 25;
      while (emoteSets.isNotEmpty) {
        var emoteSetsPack = emoteSets.take(maxSets);

        // print('== $emoteSetsPack');

        var emotesRequest = await http.get(
          Uri.parse('https://api.twitch.tv/helix/chat/emotes/set?${emoteSetsPack.map((x) => 'emote_set_id=$x').join('&')}'),
          headers: {
            'Client-ID': credentials!.clientId!,
            'Authorization': 'Bearer ${credentials!.token}',
          },
        );

        var jsonRequest = jsonDecode(emotesRequest.body);
        // print(jsonRequest);

        for (var emoteData in jsonRequest['data']) {
          newEmotes.add(
            Emote(
              name: emoteData['name'],
              id: emoteData['id'].toString(),
              set: emoteData['emote_set_id'],
              provider: 'Twitch',
              mipmap: [
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/1.0',
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/2.0',
                'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/3.0',
                // // 'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData['id']}/default/dark/4.0',
                // for (var url in emoteData['images'].values) url,
              ],
              // mipmap: List<String>.from(emoteData['images'].values),
            ),
          );
        }

        emoteSets = emoteSets.sublist(min(emoteSets.length, maxSets));
      }
      emotes = newEmotes;
    }
  }

  Connection({
    this.client,
    this.transmission = false,
    this.credentials,
  }) {
    client!.listeners.forEach((listener) => listener.onConnectionStateChange(this, state));

    connect(credentials);
  }

  void joinWhisper(String name) {
    whispers.add(Channel(
      client: client,
      receiver: this,
      transmitter: this,
      name: name,
      id: 0,
    ));
  }

  void partWhisper(String name) {
    whispers.removeWhere((element) => element!.name == name);
  }

  void send(String data) async {
    var message = IRCMessage.fromData(data);
    // print('\x1b[31m< $name: ${message.command}: \x1b[37m$data\x1b[37m');
    webSocketChannel!.sink.add(data);
  }

  void receive(String data) async {
    var message = IRCMessage.fromData(data);
    // print('\x1b[32m> $name: ${message.command}: \x1b[37m$data\x1b[37m');

    switch (message?.command) {
      case '372':
        stateChanger = ConnectionState.Connected;
        // await updateUserEmotes();
        break;
      case 'GLOBALUSERSTATE':
        if (transmission) {
          await updateUserEmotes(emoteSets: message!.tags['emote-sets'].split(','));
          await client!.updateBadges();
        }
        break;
      case 'PING':
        send('PONG :${message!.parameters[1]}'); //  ?? 'tmi.twitch.tv'
        break;
      case 'RECONNECT':
        // print('$name: Reconnect requested');
        stateChanger = ConnectionState.Reconnecting;
        await Future.delayed(Duration(seconds: 4));
        connect(credentials);
        break;
      case 'ROOMSTATE':
        var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);
        channel?.stateChanger = ChannelState.Connected;
        channel?.id = int.tryParse(message!.tags['room-id']) ?? 22484632;
        await channel?.updateEmotes();
        await channel?.updateBadges();
        await channel?.updateUsers();
        await channel?.loadHistory();
        break;
      case 'NOTICE':
        var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);
        if (message!.tags.containsKey('msg-id') ? message.tags['msg-id'] == 'msg_channel_suspended' : false) channel?.stateChanger = ChannelState.Suspended;
        if (message.tags.containsKey('msg-id') ? message.tags['msg-id'] == 'msg_banned' : false) channel?.stateChanger = ChannelState.Banned;
        try {
          var chatMessage = Message(
            channel: channel,
            id: message.tags['id'],
            body: message.parameters[1],
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.tags['tmi-sent-ts']) ?? 0),
          );

          client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));

          channel?.messages.add(chatMessage);
          if ((channel?.messages.length ?? 0) > 1000) channel?.messages.removeRange(0, (channel.messages.length) - 1000);
        } catch (e) {}
        break;
      case 'PRIVMSG':
        var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);

        var chatMessage = Message(
          channel: channel,
          user: User(
            login: message!.prefix.split('!').first.toLowerCase(),
            displayName: message.tags['display-name'],
            id: int.tryParse(message.tags['user-id']),
            color: (message.tags['color'] == null || message.tags['color'].trim().isEmpty ? null : message.tags['color'].substring(1)),
          ),
          id: message.tags['id'],
          body: message.parameters[1],
          tagBadges: message.tags['badges'],
          tagEmotes: message.tags['emotes'],
        );

        client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));

        channel?.messages.add(chatMessage);
        if ((channel?.messages.length ?? 0) > 1000) channel?.messages.removeRange(0, (channel.messages.length) - 1000);
        break;
      case 'WHISPER':
        if (!transmission) break;
        var name = message!.prefix.split('!').first;
        var channel = whispers.firstWhere((channel) => channel!.name == name, orElse: () {
          joinWhisper(name);
          return whispers.firstWhere((channel) => channel!.name == name, orElse: () => null);
        });
        if (channel == null) break;

        var chatMessage = Message(
          channel: channel,
          user: User(
            login: message.prefix.split('!').first.toLowerCase(),
            displayName: message.tags['display-name'],
            id: int.tryParse(message.tags['user-id']),
            color: (message.tags['color'] == null || message.tags['color'].trim().isEmpty ? null : message.tags['color'].substring(1)),
          ),
          id: message.tags['id'],
          body: message.parameters[1],
          // tagBadges: message.tags['badges'],
          tagEmotes: message.tags['emotes'],
        );

        channel.messages.add(chatMessage);
        client!.listeners.forEach((listener) => listener.onWhisper(channel, chatMessage));
        break;

      case 'CLEARMSG':
        try {
          print(message?.raw);
          var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);
          // var channel = client.channels.state.firstWhere((channel) => channel.state is ChannelStateWithConnection && (channel.state as ChannelStateWithConnection).receiver == this && channel.name == channelName);

          var chatMessage = Message(
            channel: channel,
            id: message!.tags['id'],
            body: 'A message from ${message.tags['login']} was deleted: ${message.parameters[1]}',
            dateTime: DateTime.now(),
          );

          client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));

          channel?.messages.add(chatMessage);
          if ((channel?.messages.length ?? 0) > 1000) channel?.messages.removeRange(0, (channel.messages.length) - 1000);
        } catch (e) {}
        break;
      case 'CLEARCHAT':
        try {
          var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);
          var duration = message!.tags['ban-duration'] == null ? null : Duration(seconds: int.tryParse(message.tags['ban-duration']) ?? 0);
          var uid = int.tryParse(message.tags['target-user-id'] ?? '');

          if (uid != null) {
            channel?.messages.where((msg) => msg.user != null && msg.user!.id == uid).forEach((element) {
              element.deleted = true;
            });
          } else {
            channel?.messages.forEach((element) {
              element.deleted = true;
            });
          }

          var chatMessage = Message(
            channel: channel,
            // id: message.tags['id'],
            body: uid != null ? '${message.parameters[1]} has been ' + (duration != null ? 'timed out for $duration' : 'permabanned') : 'Chat has been cleared by a moderator',
            dateTime: DateTime.now(),
          );

          client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));

          channel?.messages.add(chatMessage);
          if ((channel?.messages.length ?? 0) > 1000) channel?.messages.removeRange(0, (channel.messages.length) - 1000);
        } catch (e) {}
        break;
      case 'USERNOTICE':
        try {
          // Raid:
          // @badge-info=;badges=;color=#FF69B4;display-name=TimeClova;emotes=;flags=;id=02139f6a-5cc1-4515-8b0c-aca140a6d6cd;login=timeclova;mod=0;msg-id=raid;msg-param-displayName=TimeClova;msg-param-login=timeclova;msg-param-profileImageURL=https://static-cdn.jtvnw.net/jtv_user_pictures/85e6c1f6-ae9a-4534-a7b4-bcb89a05c1de-profile_image-70x70.png;msg-param-viewerCount=56;room-id=192434734;subscriber=0;system-msg=56\sraiders\sfrom\sTimeClova\shave\sjoined!;tmi-sent-ts=1627730280158;user-id=590368354;user-type= :tmi.twitch.tv USERNOTICE #aimsey

          // Sub with message:
          // @badge-info=subscriber/4;badges=subscriber/3,premium/1;color=#008000;display-name=surbeonxbox;emotes=;flags=;id=707c4e3c-3cb7-422e-9c1c-00bd431338bc;login=surbeonxbox;mod=0;msg-id=resub;msg-param-cumulative-months=4;msg-param-months=0;msg-param-multimonth-duration=0;msg-param-multimonth-tenure=0;msg-param-should-share-streak=1;msg-param-streak-months=4;msg-param-sub-plan-name=Channel\sSubscription\s(xqcow);msg-param-sub-plan=1000;msg-param-was-gifted=false;room-id=71092938;subscriber=1;system-msg=surbeonxbox\ssubscribed\sat\sTier\s1.\sThey've\ssubscribed\sfor\s4\smonths,\scurrently\son\sa\s4\smonth\sstreak!;tmi-sent-ts=1627730157904;user-id=514719264;user-type= :tmi.twitch.tv USERNOTICE #xqcow :YUP

          // Gifted sub:
          // @badge-info=subscriber/13;badges=subscriber/12,glhf-pledge/1;color=#A175B7;display-name=Tharus1337;emotes=;flags=;id=921661da-239e-462d-9a65-5779104816e1;login=tharus1337;mod=0;msg-id=subgift;msg-param-gift-months=1;msg-param-months=32;msg-param-origin-id=b3\s21\sd7\s86\s67\s5c\s59\sdd\sd3\s56\sde\s65\se7\s54\s36\s6e\s17\s76\s82\se0;msg-param-recipient-display-name=truncated_xD;msg-param-recipient-id=91434296;msg-param-recipient-user-name=truncated_xd;msg-param-sender-count=1;msg-param-sub-plan-name=Channel\sSubscription\s(forsenlol);msg-param-sub-plan=1000;room-id=22484632;subscriber=1;system-msg=Tharus1337\sgifted\sa\sTier\s1\ssub\sto\struncated_xD!\sThis\sis\stheir\sfirst\sGift\sSub\sin\sthe\schannel!;tmi-sent-ts=1627730596864;user-id=72864797;user-type= :tmi.twitch.tv USERNOTICE #forsen

          // Sub with message 2:
          // @badge-info=;badges=glhf-pledge/1;color=#FF1493;display-name=splizhh;emotes=;flags=;id=92a97eba-d684-406d-8ca3-21e95c1cc874;login=splizhh;mod=0;msg-id=resub;msg-param-cumulative-months=6;msg-param-months=0;msg-param-multimonth-duration=0;msg-param-multimonth-tenure=0;msg-param-should-share-streak=1;msg-param-streak-months=5;msg-param-sub-plan-name=Channel\sSubscription\s(xqcow);msg-param-sub-plan=Prime;msg-param-was-gifted=false;room-id=71092938;subscriber=1;system-msg=splizhh\ssubscribed\swith\sPrime.\sThey've\ssubscribed\sfor\s6\smonths,\scurrently\son\sa\s5\smonth\sstreak!;tmi-sent-ts=1627742216686;user-id=230654107;user-type= :tmi.twitch.tv USERNOTICE #xqcow :pog

          var channel = channels.firstWhereOrNull((channel) => channel.name == message!.parameters[0]);

          var chatMessage = Message(
            channel: channel,
            id: message!.tags['id'],
            body: message.tags['system-msg'].replaceAll('\\s', ' ') + message.parameters.length >= 2 ? message.parameters[1] : '',
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.tags['tmi-sent-ts']) ?? 0),
            user: User(
              login: message.prefix.split('!').first,
              displayName: message.tags['display-name'],
              id: int.tryParse(message.tags['user-id']),
              color: message.tags['color'],
            ),
          );

          client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));

          channel?.messages.add(chatMessage);
          if ((channel?.messages.length ?? 0) > 1000) channel?.messages.removeRange(0, (channel.messages.length) - 1000);
        } catch (e) {}
        break;
    }
  }

  void connect(Credentials? newCredentials) async {
    await dispose();

    credentials = newCredentials ?? credentials;

    webSocketChannel = connectWebSocket('wss://irc-ws.chat.twitch.tv:443');
    send('CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
    if (credentials!.token != null) send('PASS oauth:${credentials!.token}');
    send('NICK ${credentials!.login}');

    streamSubscription = webSocketChannel!.stream.listen(
      (event) async {
        for (var message in event.trim().split('\r\n')) {
          receive(message);
        }
      },
      onError: (e) async {
        // print('$name: An error has occured: $e');
        stateChanger = ConnectionState.SocketError;
        await Future.delayed(Duration(seconds: 4));
        connect(credentials);
      },
      onDone: () async {
        // print('$name: Connection terminated');
        stateChanger = ConnectionState.SocketTerminated;
        await Future.delayed(Duration(seconds: 4));
        connect(credentials);
      },
      cancelOnError: true,
    );
  }

  Future<void> dispose() async {
    stateChanger = ConnectionState.Disconnected;
    await streamSubscription?.cancel();
    webSocketChannel = null;
  }
}

class Client {
  List<Listener> listeners = [];

  Credentials credentials;
  Map<Credentials?, List<Connection>> receivers = {};
  Map<Credentials?, Connection> transmitters = {};
  List<Channel> channels = [];
  List<Emote> emotes = [];
  List<Emote> emojis = [];
  List<Badge> badges = [];
  bool useRecentMessages;

  Timer? timer;

  // TODO: Rework this
  Future<void> updateBadges() async {
    badges.clear();

    try {
      var request = await http.get(
        Uri.parse('https://api.twitch.tv/helix/chat/badges/global'), // https://badges.twitch.tv/v1/badges/global/display
        headers: {
          'Client-ID': credentials.clientId!,
          'Authorization': 'Bearer ${credentials.token}',
        },
      );
      var jsonRequest = jsonDecode(request.body);

      for (var categories in jsonRequest['data']) {
        for (var badgeData in categories['versions']) {
          badges.add(
            Badge.fromJson(
              categories['set_id'],
              badgeData['id'],
              badgeData,
            ),
          );
        }
      }
    } catch (e) {
      print('Couldn\'t load Twitch global badges');
    }
  }

  // TODO: Rework this to not clear emotes before they are acquired and only clear if we can receive new ones, maybe return difference?
  Future<void> updateEmotes() async {
    emotes.clear();
    emojis.clear();

    try {
      var response = await http.get(Uri.parse('https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji.json'));
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      for (var entry in jsonResponse.where((entry) => entry['has_img_twitter'] == true)) {
        var emote = Emote(
          alt: entry['unified'].split('-').map((x) => String.fromCharCode(int.parse(x, radix: 16))).join(),
          name: entry['short_name'],
          // id: emoteData['id'],
          provider: 'Emoji',
          // mipmap: List<String>.from(
          //   emoteData['urls'].values.map(
          //         (url) => 'https:$url',
          //       ),
          // ),
          mipmap: [
            'https://raw.githubusercontent.com/iamcal/emoji-data/master/img-twitter-72/${entry['image']}',
          ],
        );

        emojis.add(emote);
      }
    } catch (e) {
      // print(e);
      print('Couldn\'t load emojis');
    }

    try {
      final staticEmotes = await ChatsenStatic.staticEmotes();

      for (final staticEmote in staticEmotes) {
        emotes.add(
          Emote(
            name: staticEmote.name,
            id: staticEmote.id,
            provider: 'Chatsen',
            mipmap: [
              staticEmote.url,
            ],
            zeroWidth: (staticEmote.modifiers & (1 << 1)) == (1 << 1),
          ),
        );
      }
    } catch (e) {
      print("Couldn't fetch Chatsen static emotes");
    }

    try {
      var emotesRequest = await http.get(Uri.parse('https://api.frankerfacez.com/v1/set/global'));
      var jsonRequest = jsonDecode(emotesRequest.body);

      for (var emoteSetEntry in jsonRequest['sets'].entries) {
        var emoteSet = emoteSetEntry.value;
        for (var emoteData in emoteSet['emoticons']) {
          var emote = Emote(
            name: emoteData['name'],
            // id: emoteData['id'],
            provider: 'FFZ',
            mipmap: [
              for (var url in emoteData['urls'].values) url.startsWith('http') ? url : 'https:$url',
            ],
          );

          emotes.add(emote);
        }
      }
    } catch (e) {
      print("Couldn't fetch FFZ emotes");
    }

    try {
      var emotesRequest = await http.get(Uri.parse('https://api.betterttv.net/3/cached/emotes/global'));
      var jsonRequest = jsonDecode(emotesRequest.body);

      for (var emoteData in jsonRequest) {
        var emote = Emote(
          name: emoteData['code'],
          id: emoteData['id'],
          provider: 'BTTV',
          mipmap: [
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/1x',
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/2x',
            'https://cdn.betterttv.net/emote/${emoteData["id"]}/3x',
            // 'https://cdn.betterttv.net/emote/${emoteData["id"]}/4x',
          ],
        );

        emotes.add(emote);
      }
    } catch (e) {
      print("Couldn't fetch BTTV emotes");
    }

    try {
      // for (var i = 1; true; ++i) {
      //   var data = await GQL.request7('''
      //     query {
      //       search_emotes(query: "", globalState: "only", limit: 150, pageSize: 150, page: $i) {
      //         id
      //         name
      //         urls
      //         provider
      //         visibility
      //       }
      //     }
      //   ''');

      //   var emotesData = data['data']['search_emotes'];

      //   for (var emoteData in emotesData) {
      //     if (emoteData['urls'].isEmpty) {
      //       continue;
      //     }

      //     var emote = Emote(
      //       name: emoteData['name'],
      //       id: emoteData['id'],
      //       provider: '7TV',
      //       mipmap: [
      //         for (var url in emoteData['urls']) url.last,
      //       ],
      //       zeroWidth: (emoteData['visibility'] & (1 << 7)) == (1 << 7),
      //     );

      //     emotes.add(emote);
      //   }

      //   if (emotesData.length < 150) break;
      // }

      // https://api.7tv.app/v3/emote-sets/global 
      final response = await http.get(Uri.parse('https://7tv.io/v3/emote-sets/global'));
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (final emote in responseJson['emotes']) {
        emotes.add(Emote(
          name: emote['name'],
          id: emote['id'],
          provider: '7TV',
          mipmap: [
            for (final url in emote['data']['host']['files'].where((x) => x['format'] != 'AVIF')) 'https:${emote['data']['host']['url']}/${url['name']}',
          ],
          zeroWidth: (emote['data']['flags'] & (1 << 8)) == (1 << 8),
        ));
      }
    } catch (e) {
      print("Couldn't fetch 7TV emotes: $e");
    }
  }

  Client({
    this.credentials = const Credentials(),
    this.useRecentMessages = true,
  }) {
    updateEmotes();
    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) async => consumeChannelBucket(),
    );
  }

  void consumeChannelBucket() async {
    var attemptsPerSecond = 20.0 / 10.0;
    var tokens = ((attemptsPerSecond * 2.0) - 1.0).floor();
    // var tokens = (50.0 * 0.95 / 15.0 * 2.0).floor() - 2;

    var channelsToJoin = channels.where((channel) => channel.state == ChannelState.Disconnected && channel.receiver!.state == ConnectionState.Connected).take(tokens);
    var channelsToJoinGroups = groupBy(channelsToJoin, (Channel channel) => channel.receiver);
    for (var channelGroup in channelsToJoinGroups.entries) {
      channelGroup.key!.send('JOIN ${channelGroup.value.map((channel) => channel.name).join(',')}');
      channelGroup.value.forEach((channel) => channel.stateChanger = ChannelState.Connecting);
    }

    tokens -= channelsToJoin.length;

    for (var connection in receivers.values.expand((element) => element).where((connection) => connection.state == ConnectionState.Connected && connection.channelsToPart.isNotEmpty)) {
      if (tokens <= 0) break;
      var channelsToPart = connection.channelsToPart.take(tokens);
      connection.send('PART ${channelsToPart.join(',')}');
      connection.channelsToPart.removeWhere((element) => channelsToPart.contains(element));
      tokens -= channelsToPart.length;
    }
  }

  Future<void> swapCredentials(Credentials newCredentials) async {
    credentials = newCredentials;
    for (var receiver in receivers[null] ?? []) {
      receiver.connect(newCredentials);
    }
    transmitters[null]?.connect(newCredentials);
  }

  Future<List<Connection?>> acquireConnections({Credentials? receiverCredentials, Credentials? transmitterCredentials}) async {
    if (receivers[receiverCredentials] == null) {
      receivers[receiverCredentials] = <Connection>[];
    }

    var bestSuitedReceiver = receivers[receiverCredentials]!.firstWhere(
      (connection) => connection.channels.length < 100,
      orElse: () {
        var receiver = Connection(client: this, credentials: receiverCredentials ?? credentials);
        receivers[receiverCredentials]!.add(receiver);
        return receiver;
      },
    );

    if (transmitters[transmitterCredentials] == null) {
      transmitters[transmitterCredentials] = Connection(client: this, credentials: transmitterCredentials ?? credentials, transmission: true);
    }

    return [bestSuitedReceiver, transmitters[transmitterCredentials]];
  }

  Future<List<Channel>> swapChannels(List<Channel> channelsToSwap, {Credentials? receiverCredentials, Credentials? transmitterCredentials}) async {
    var swappedChannels = <Channel>[];

    for (var channel in channelsToSwap) {
      channel.receiver!.channelsToPart.add(channel.name);

      var connections = await acquireConnections(receiverCredentials: receiverCredentials, transmitterCredentials: transmitterCredentials);

      channel.receiver = connections.first;
      channel.transmitter = connections.last;
      channel.stateChanger = ChannelState.Disconnected;
      swappedChannels.add(channel);
      // TODO: Kill connection if there are no channels left
    }

    return swappedChannels;
  }

  Future<List<Channel>> joinChannels(List<dynamic> channelsToJoin, {Credentials? receiverCredentials, Credentials? transmitterCredentials}) async {
    var joinedChannels = <Channel>[];

    for (var channelToJoin in channelsToJoin) {
      if (channelToJoin.runtimeType != String) {
        throw 'Joining channels by id isn\'t supported yet.';
      }

      var connections = await acquireConnections(receiverCredentials: receiverCredentials, transmitterCredentials: transmitterCredentials);

      var channel = Channel(client: this, name: channelToJoin.toLowerCase(), receiver: connections.first, transmitter: connections.last);
      channels.add(channel);
      joinedChannels.add(channel);
    }

    return joinedChannels;
  }

  void partChannels(List<Channel> channelsToPart) async {
    for (var channelToLeave in channelsToPart) {
      channelToLeave.receiver!.channelsToPart.add(channelToLeave.name);
      channels.remove(channelToLeave);
      // TODO: Kill connection if there are no channels left
    }
  }

  void dispose() async {
    // TODO: Dispose of all receivers/transmitters
  }
}

class GQL {
  static Future<dynamic> request7(String gql, {Credentials? credentials}) async {
    var request = await http.post(
      Uri.parse('https://api.7tv.app/v2/gql'),
      body: jsonEncode({'query': gql}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(utf8.decode(request.bodyBytes));
  }
}
