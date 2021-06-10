import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
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
  final List<String?>? mipmap;

  Emote({
    this.name,
    this.id,
    this.provider,
    this.mipmap,
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

  Badge({
    this.tag,
    this.name,
    this.id,
    this.mipmap,
    this.title,
    this.description,
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
        description = json['description'];
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
    this.mention = false,
    this.dateTime,
  }) {
    if (body!.contains(RegExp('ACTION .*'))) action = true;
    if (action) body = body!.substring('ACTION '.length, body!.length - 1);

    body = body!.replaceAll(utf8.decode([0xF3, 0xA0, 0x80, 0x80]), '');

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

    tokens = tokenize(body!);

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

    var runeBody = String.fromCharCodes(runes);

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
            'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData.first}/1.0',
            'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData.first}/2.0',
            'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData.first}/3.0',
            'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData.first}/4.0',
          ],
        );
      }

      var channelEmote = channel?.emotes?.firstWhereOrNull((emote) => emote.name == messageSplit);
      var globalEmote = client?.emotes?.firstWhereOrNull((emote) => emote.name == messageSplit);
      var emote = twitchEmote ?? channelEmote ?? globalEmote;

      if (messageSplit.startsWith('http://') || messageSplit.startsWith('https://')) {
        if (messageSplit.endsWith('.png') || messageSplit.endsWith('.jpg') || messageSplit.endsWith('.jpeg') || messageSplit.endsWith('.apng') || messageSplit.endsWith('.gif')) {
          tokens.add(MessageToken.image(messageSplit));
        } else {
          tokens.add(MessageToken.link(messageSplit));
        }
      } else if (emote != null) {
        if (tokens.isNotEmpty && tokens.last.type == MessageTokenType.Emote && zeroWidthEmotes.contains(emote.name)) {
          tokens.last = MessageToken.emoteStack([tokens.last.data as Emote, emote]);
        } else if (tokens.isNotEmpty && tokens.last.type == MessageTokenType.EmoteStack && zeroWidthEmotes.contains(emote.name)) {
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
    // https://recent-messages.robotty.de/api/v2/recent-messages/
    var response = await http.get(Uri.parse('https://recent-messages.robotty.de/api/v2/recent-messages/${name!.substring(1)}'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    for (var raw in jsonResponse['messages'] ?? []) {
      var message = IRCMessage.fromData(raw);
      if (message?.command != 'PRIVMSG') {
        print(raw);
        continue;
      }

      var chatMessage = Message(
        channel: this,
        user: User(
          login: message!.prefix.split('!').first.toLowerCase(),
          displayName: message.tags['display-name'],
          id: int.tryParse(message.tags['user-id'] ?? '0'),
          color: (message.tags['color'] == null || message.tags['color'].trim().isEmpty ? null : message.tags['color'].substring(1)),
        ),
        id: message.tags['id'],
        body: message.parameters[1],
        mention: message.parameters[1].toLowerCase().contains(receiver!.credentials!.login.toLowerCase()), // TODO: Move to message's constructor
        tagBadges: message.tags['badges'],
        tagEmotes: message.tags['emotes'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.tags['tmi-sent-ts']) ?? 0),
      );

      messages.add(chatMessage);
      if (messages.length > 1000) messages.removeRange(0, messages.length - 1000);
    }

    client!.listeners.forEach((listener) => listener.onHistoryLoaded(this));
  }

  // TODO: Rework this
  Future<dynamic> updateUsers() async {
    var userListQuery = await GQL.request('''
          query {
            channel(id: "$id") {
              chatters {
                staff {
                  login
                }
                broadcasters {
                  login
                }
                moderators {
                  login
                }
                vips {
                  login
                }
                viewers {
                  login
                }
              }
            }
          }
        ''');

    users = (userListQuery['data']['channel']['chatters'] as Map<String, dynamic>).map(
      (key, chatterList) => MapEntry<String, List<String>>(
        key,
        List<String>.from(
          chatterList.map(
            (chatter) => chatter['login'],
          ),
        ),
      ),
    );

    return users;
  }

  // TODO: Rework this
  Future<void> updateBadges() async {
    badges.clear();
    print('hi');

    try {
      var request = await http.get(Uri.parse('https://badges.twitch.tv/v1/badges/channels/$id/display?language=en'));
      var jsonRequest = jsonDecode(request.body);

      for (var categories in jsonRequest['badge_sets'].entries) {
        for (var badgeData in categories.value['versions'].entries) {
          badges.add(
            Badge.fromJson(
              categories.key,
              badgeData.key,
              badgeData.value,
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
            mipmap: List<String>.from(
              emoteData['urls'].values.map(
                    (url) => 'https:$url',
                  ),
            ),
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
      var data = await GQL.request7('''
        query {
          user(id: "${name!.substring(1).toLowerCase()}") {
            emotes {
              id
              name
              urls
              provider
            }
          }
        }
      ''');

      for (var emoteData in data['data']['user']['emotes']) {
        var emote = Emote(
          name: emoteData['name'],
          id: emoteData['id'],
          provider: '7TV',
          mipmap: [
            for (var url in emoteData['urls']) url.last,
          ],
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
    // TODO: Setup per-channel spam bypass
    // TODO: Handle whispers

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
        mention: message.toLowerCase().contains(receiver!.credentials!.login.toLowerCase()), // TODO: Move to message's constructor
        dateTime: DateTime.now(),
      );

      messages.add(chatMessage);
      client!.listeners.forEach((listener) => listener.onWhisper(this, chatMessage));
    } else {
      transmitter?.send('PRIVMSG $name :$message');
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

  Future<void> updateUserEmotes() async {
    emotes.clear();

    if (credentials == null || credentials!.token == null || credentials!.clientId == null || credentials!.id == null) {
      return;
    }

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
              'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData['id']}/1.0',
              'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData['id']}/2.0',
              'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData['id']}/3.0',
              'https://static-cdn.jtvnw.net/emoticons/v1/${emoteData['id']}/4.0',
            ],
          ),
        );
      }
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
        await updateUserEmotes();
        break;
      case 'PING':
        send('PONG :${message!.parameters[1] ?? 'tmi.twitch.tv'}');
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
          mention: message.parameters[1].toLowerCase().contains(credentials!.login.toLowerCase()), // TODO: Move to message's constructor
          tagBadges: message.tags['badges'],
          tagEmotes: message.tags['emotes'],
        );

        channel?.messages?.add(chatMessage);
        if ((channel?.messages?.length ?? 0) > 1000) channel?.messages?.removeRange(0, (channel?.messages?.length ?? 0) - 1000);

        client!.listeners.forEach((listener) => listener.onMessage(channel, chatMessage));
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
          mention: message.parameters[1].toLowerCase().contains(credentials!.login.toLowerCase()), // TODO: Move to message's constructor
          // tagBadges: message.tags['badges'],
          tagEmotes: message.tags['emotes'],
        );

        channel.messages.add(chatMessage);
        client!.listeners.forEach((listener) => listener.onWhisper(channel, chatMessage));
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
  List<Badge> badges = [];

  Timer? timer;

  // TODO: Rework this
  Future<void> updateBadges() async {
    badges.clear();

    try {
      var request = await http.get(Uri.parse('https://badges.twitch.tv/v1/badges/global/display'));
      var jsonRequest = jsonDecode(request.body);

      for (var categories in jsonRequest['badge_sets'].entries) {
        for (var badgeData in categories.value['versions'].entries) {
          badges.add(
            Badge.fromJson(
              categories.key,
              badgeData.key,
              badgeData.value,
            ),
          );
        }
      }
    } catch (e) {
      print('Couldn\'t load Twitch global badges');
    }
  }

  // TODO: Rework this to not clear emotes before they are acquired and only clear if we can receive new ones, maybe return difference?
  void updateEmotes() async {
    emotes.clear();

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
            mipmap: List<String>.from(
              emoteData['urls'].values.map(
                    (url) => 'https:$url',
                  ),
            ),
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
      for (var i = 1; true; ++i) {
        var data = await GQL.request7('''
          query {
            search_emotes(query: "", globalState: "only", limit: 150, pageSize: 150, page: $i) {
              id
              name
              urls
              provider
            }
          }
        ''');

        var emotesData = data['data']['search_emotes'];

        for (var emoteData in emotesData) {
          var emote = Emote(
            name: emoteData['name'],
            id: emoteData['id'],
            provider: '7TV',
            mipmap: [
              for (var url in emoteData['urls']) url.last,
            ],
          );

          emotes.add(emote);
        }

        if (emotesData.length < 150) break;
      }
    } catch (e) {
      print("Couldn't fetch 7TV emotes: $e");
    }
  }

  Client({
    this.credentials = const Credentials(),
  }) {
    updateEmotes();
    updateBadges();
    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) async => consumeChannelBucket(),
    );
  }

  void consumeChannelBucket() async {
    var tokens = (50.0 * 0.95 / 15.0 * 2.0).floor() - 2;

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

  void swapCredentials(Credentials newCredentials) async {
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
  static String endpoint = 'https://gql.twitch.tv/gql';

  static Future<dynamic> request(String gql, {Credentials? credentials}) async {
    var request = await http.post(
      Uri.parse(endpoint),
      body: jsonEncode({'query': gql}),
      headers: {
        // 'Authorization': 'OAuth xxx',
        'Client-Id': 'kimne78kx3ncx6brgo4mv6wki5h1ko',
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(utf8.decode(request.bodyBytes));
  }

  static Future<dynamic> request7(String gql, {Credentials? credentials}) async {
    var request = await http.post(
      Uri.parse('https://api.7tv.app/v2/gql'),
      body: jsonEncode({'query': gql}),
      headers: {
        // 'Authorization': 'OAuth xxx',
        // 'Client-Id': 'kimne78kx3ncx6brgo4mv6wki5h1ko',
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(utf8.decode(request.bodyBytes));
  }
}
