import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../channel/channel.dart';
import '../channel/channel_state.dart';
import 'client.dart';

class ClientChannels extends Cubit<List<Channel>> {
  Client client;
  Box channelsBox;

  ClientChannels(
    this.client, {
    required this.channelsBox,
  }) : super([]) {
    joinAll(List<String>.from(channelsBox.values), save: false);
  }

  void join(String channelName) {
    channelsBox.add(channelName);

    emit([
      ...state,
      Channel(
        client: client,
        name: channelName,
      ),
    ]);
  }

  void part(Channel channel) {
    final x = List<String>.from(channelsBox.values).indexWhere((element) => element == channel.name);
    channelsBox.deleteAt(x);

    if (channel.state is ChannelStateWithConnection) {
      (channel.state as ChannelStateWithConnection).receiver.send('PART ${channel.name}');
    }

    emit([
      ...state.where((element) => element != channel),
    ]);
  }

  void joinAll(List<String> channelNames, {bool save = true}) {
    if (save) channelsBox.addAll(channelNames.where((x) => !state.contains(x)));

    emit([
      ...state,
      for (var channelName in channelNames)
        Channel(
          client: client,
          name: channelName,
        ),
    ]);
  }
}
