import 'package:bloc/bloc.dart';

import '../channel/channel.dart';
import '../channel/channel_state.dart';

class ClientChannels extends Cubit<List<Channel>> {
  ClientChannels() : super([]);

  void join(String channelName) => emit([
        ...state,
        Channel(name: channelName),
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
        for (var channelName in channelNames) Channel(name: channelName),
      ]);
}
