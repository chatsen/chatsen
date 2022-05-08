import 'package:bloc/bloc.dart';
import 'package:chatsen/providers/twitch.dart';
import 'package:chatsen/tmi/badges.dart';
import 'package:collection/collection.dart';

import '../../data/badge.dart';
import '../../data/emote.dart';
import '../../providers/badge_provider.dart';
import '../../providers/emote_provider.dart';
import '../emotes.dart';
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
    SevenTVProvider(),
    BetterTTVProvider(),
    FrankerFaceZProvider(),
    TwitchProvider(),
  ];

  late ClientChannels channels;

  Emotes globalEmotes = Emotes();
  Badges globalBadges = Badges();
  Emotes emojis = Emotes();

  Client({
    TwitchAccount? twitchAccount,
  }) {
    channels = ClientChannels(this);

    receiver.onReceive = receive;
    transmitter.onReceive = receive;
    receiver.onStateChange = stateChange;

    if (twitchAccount != null) connectAs(twitchAccount);

    refreshGlobalEmotes();
    refreshGlobalBadges();
  }

  Future<void> refreshGlobalEmotes() async {
    final emotes = <Emote>[];
    final emoteProviders = providers.whereType<EmoteProvider>();
    for (final emoteProvider in emoteProviders) {
      try {
        emotes.addAll(await emoteProvider.globalEmotes());
      } catch (e) {
        print('Couldn\'t get ${emoteProvider.name} global emotes');
      }
    }

    globalEmotes.emit(emotes);
  }

  Future<void> refreshGlobalBadges() async {
    final badges = <Badge>[];
    final badgeProviders = providers.whereType<BadgeProvider>();
    for (final badgeProvider in badgeProviders) {
      try {
        badges.addAll(await badgeProvider.globalBadges());
      } catch (e) {
        print('Couldn\'t get ${badgeProvider.name} global badges');
      }
    }

    globalBadges.emit(badges);
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
      case 'PRIVMSG':
        final channelName = event.parameters[0];
        final channel = channels.state.firstWhereOrNull((channel) => channel.name == channelName);
        if (channel == null) {
          break;
        }

        channel.channelMessages.add(
          ChannelMessageChat(
            message: event,
            dateTime: DateTime.now(),
            channel: channel,
          ),
        );
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
    }
  }
}
