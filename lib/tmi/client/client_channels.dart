import 'package:bloc/bloc.dart';

import '../channel/channel.dart';
import '../channel/channel_state.dart';
import 'client.dart';

class ClientChannels extends Cubit<List<Channel>> {
  Client client;

  ClientChannels(this.client) : super([]);

  void join(String channelName) => emit([
        ...state,
        Channel(
          client: client,
          name: channelName,
        ),
      ]);

  void part(Channel channel) {
    if (channel.state is ChannelStateWithConnection) {
      (channel.state as ChannelStateWithConnection).receiver.send('PART ${channel.name}');
    }

    emit([
      ...state.where((element) => element != channel),
    ]);
  }

  void joinAll(List<String> channelNames) => emit([
        ...state,
        for (var channelName in channelNames)
          Channel(
            client: client,
            name: channelName,
          ),
      ]);
}
