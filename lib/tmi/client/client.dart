import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatsen/providers/dankchat.dart';
import 'package:chatsen/providers/emojis.dart';
import 'package:chatsen/providers/twitch.dart';
import 'package:chatsen/tmi/badges.dart';
import 'package:chatsen/tmi/channel/channel_message.dart';
import 'package:chatsen/tmi/client/client_listener.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/custom_badge.dart';
import '../../data/badge_users.dart';
import '../../data/emote.dart';
import '../../providers/badge_provider.dart';
import '../../providers/chatsen.dart';
import '../../providers/emote_provider.dart';
import '../channel/messages/channel_message_ban.dart';
import '../channel/messages/channel_message_notice.dart';
import '../emotes.dart';
import '../user_badges.dart';
import '/providers/betterttv.dart';
import '/api/recentmessages/recentmessages.dart';
import '/tmi/channel/channel_event.dart';
import '/tmi/channel/channel_state.dart';
import '/tmi/connection/connection_state.dart';
import '/data/twitch_account.dart';
import '/tmi/connection/connection.dart';
import '/tmi/connection/connection_event.dart';
import '/irc/message.dart' as irc;
import '/providers/provider.dart';
import '/providers/frankerfacez.dart';
import '/providers/seventv.dart';
import '/tmi/channel/messages/channel_message_chat.dart';
import 'client_channels.dart';

class Client {
  Connection receiver = Connection();
  Connection transmitter = Connection();

  List<Provider> providers = [
    ChatsenProvider(),
    SevenTVProvider(),
    BetterTTVProvider(),
    FrankerFaceZProvider(),
    DankChatProvider(),
    TwitchProvider(),
    EmojiProvider(),
  ];

  late ClientChannels channels;

  List<ClientListener> listeners = [];

  Emotes globalEmotes = Emotes();
  Badges globalBadges = Badges();
  Emotes emojis = Emotes();
  UserBadges globalUserBadges = UserBadges();

  Client({
    TwitchAccount? twitchAccount,
    required Box channelsBox,
  }) {
    channels = ClientChannels(
      this,
      channelsBox: channelsBox,
    );

    Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (receiver.state is ConnectionConnected) {
          const double tmiJoinPerSecond = 20.0 / 30.0;
          final channelsToJoin = channels.state.where((channel) => channel.state is ChannelDisconnected).take((tmiJoinPerSecond * 2).floor());
          if (channelsToJoin.isEmpty) return;
          print(channelsToJoin.map((e) => e.name).join(','));
          for (final channel in channelsToJoin) channel.add(ChannelJoin(receiver, transmitter));
          receiver.send('JOIN ${channelsToJoin.map((e) => e.name).join(',')}');
        }
      },
    );

    receiver.onReceive = receive;
    transmitter.onReceive = receive;
    receiver.onStateChange = stateChange;

    if (twitchAccount != null) connectAs(twitchAccount);

    refreshGlobalEmotes();
    refreshGlobalBadges();
    refreshGlobalUserBadges();
  }

  Future<void> refreshGlobalEmotes() async {
    final emotes = <Emote>[];
    final emoteProviders = providers.whereType<EmoteProvider>();
    for (final emoteProvider in emoteProviders) {
      try {
        emotes.addAll(await emoteProvider.globalEmotes());
      } catch (e) {
        log('Couldn\'t get ${emoteProvider.name} global emotes');
      }
    }

    globalEmotes.change(emotes);
  }

  Future<void> refreshGlobalBadges() async {
    final badges = <CustomBadge>[];
    final badgeProviders = providers.whereType<BadgeProvider>();
    for (final badgeProvider in badgeProviders) {
      try {
        badges.addAll(await badgeProvider.globalBadges());
      } catch (e) {
        log('Couldn\'t get ${badgeProvider.name} global badges');
      }
    }

    globalBadges.change(badges);
  }

  Future<void> refreshGlobalUserBadges() async {
    final badges = <BadgeUsers>[];
    final badgeProviders = providers.whereType<BadgeProvider>();
    for (final badgeProvider in badgeProviders) {
      try {
        badges.addAll(await badgeProvider.globalUserBadges());
      } catch (e) {
        log('Couldn\'t get ${badgeProvider.name} global badges');
      }
    }

    globalUserBadges.change(badges);
  }

  Future<void> connectAs(TwitchAccount twitchAccount) async {
    receiver.add(ConnectionConnect(twitchAccount));
    transmitter.add(ConnectionConnect(twitchAccount));
  }

  Future<void> stateChange(Connection connection, Change<ConnectionState> change) async {
    // final matchingChannels = channels.state.where((channel) => channel.state is ChannelStateWithConnection && (channel.state as ChannelStateWithConnection).receiver == this);
    for (final channel in channels.state) {
      channel.add(ChannelPart());
    }
  }

  Future<void> receive(Connection connection, irc.Message event) async {
    // print('$connection: ${event.raw}');
    switch (event.command) {
      case '001':
        if (connection.state is ConnectionConnecting) connection.emit(ConnectionConnected((connection.state as ConnectionConnecting).twitchAccount));
        break;
      case 'JOIN':
        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        final credentials = channel.state is ChannelStateWithConnection ? (channel.state as ChannelStateWithConnection).receiver.twitchAccount : null;
        if (credentials == null) {
          break;
        }

        final loginSource = event.prefix?.split('!').first;
        if (loginSource == credentials.tokenData.login) {
          channel.add(ChannelConnect());
          for (final message in (await RecentMessages.channel(channel.name.substring(1)))) {
            final ircMessage = irc.Message.fromEvent(message);
            if (ircMessage.command == 'ROOMSTATE') continue;
            receive(connection, ircMessage);
          }
        }
        break;
      case 'USERNOTICE':
      case 'PRIVMSG':
        if (event.command == 'USERNOTICE') log(event.raw);

        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        ChannelMessage message = ChannelMessageChat(
          message: event,
          dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(event.tags['tmi-sent-ts'] ?? 'null') ?? DateTime.now().millisecondsSinceEpoch),
          channel: channel,
        );

        for (final listener in listeners) {
          listener.onMessageReceived(message);
        }

        channel.channelMessages.add(message);
        break;
      case 'ROOMSTATE':
        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        channel.id = event.tags['room-id'];
        await channel.refresh();
        break;
      case 'CLEARCHAT':
        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        channel.channelMessages.add(
          ChannelMessageBan(
            message: event,
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(event.tags['tmi-sent-ts'] ?? 'null') ?? DateTime.now().millisecondsSinceEpoch),
            channel: channel,
          ),
        );
        break;
      case 'NOTICE':
        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        channel.channelMessages.add(
          ChannelMessageNotice(
            message: event,
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(event.tags['tmi-sent-ts'] ?? 'null') ?? DateTime.now().millisecondsSinceEpoch),
            channel: channel,
          ),
        );
        break;
      default:
        log(event.raw);
        break;
    }
  }
}
