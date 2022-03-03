import '/tmi/channel/channel.dart';
import '../channel_event.dart';
import '../channel_message.dart';

class ChannelMessageEvent extends ChannelMessage {
  ChannelEvent channelEvent;

  ChannelMessageEvent({
    required this.channelEvent,
    required DateTime dateTime,
    Channel? channel,
  }) : super(
          dateTime: dateTime,
          channel: channel,
        );
}
