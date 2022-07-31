import '../channel_event.dart';
import '../channel_message.dart';

class ChannelMessageEvent extends ChannelMessage {
  ChannelEvent channelEvent;

  ChannelMessageEvent({
    required this.channelEvent,
    required super.dateTime,
    super.channel,
  });
}
