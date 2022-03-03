import 'channel.dart';

abstract class ChannelMessage {
  final DateTime dateTime;
  final Channel? channel;

  const ChannelMessage({
    required this.dateTime,
    this.channel,
  });
}
