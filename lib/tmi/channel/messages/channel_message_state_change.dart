import 'package:bloc/bloc.dart';

import '/tmi/channel/channel_state.dart';
import '../channel.dart';
import '../channel_message.dart';

class ChannelMessageStateChange extends ChannelMessage {
  Change<ChannelState> change;

  ChannelMessageStateChange({
    required this.change,
    required DateTime dateTime,
    Channel? channel,
  }) : super(
          dateTime: dateTime,
          channel: channel,
        );
}
