import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

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
  ClientChannels channels = ClientChannels();
  List<Provider> providers = [
    SevenTVProvider(),
    BetterTTVProvider(),
    FrankerFaceZProvider(),
  ];

  Client({
    TwitchAccount? twitchAccount,
  }) {
    receiver.onReceive = receive;
    transmitter.onReceive = receive;
    receiver.onStateChange = stateChange;

    if (twitchAccount != null) connectAs(twitchAccount);
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
            receive(connection, irc.Message.fromEvent(message));
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
        break;
    }
  }
}
