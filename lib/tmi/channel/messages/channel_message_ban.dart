import '../../user.dart';
import '../channel_message.dart';

import '/irc/message.dart' as irc;

class ChannelMessageBan extends ChannelMessage {
  irc.Message message;
  User? user;
  Duration? duration;

  ChannelMessageBan({
    required this.message,
    required super.dateTime,
    super.channel,
  }) {
    if (message.tags['target-user-id'] != null) {
      user = User(
        login: message.parameters[1],
        displayName: message.parameters[1],
        id: message.tags['target-user-id'],
      );
      duration = Duration(seconds: int.tryParse(message.tags['ban-duration'] ?? '0') ?? 0);
    }
  }
}
