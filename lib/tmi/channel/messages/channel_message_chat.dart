import '../channel.dart';
import '../channel_message.dart';
import '/irc/message.dart' as irc;

class ChannelMessageChat extends ChannelMessage {
  irc.Message message;

  ChannelMessageChat({
    required this.message,
    required DateTime dateTime,
    Channel? channel,
  }) : super(
          dateTime: dateTime,
          channel: channel,
        );
}
