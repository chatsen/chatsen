import 'package:chatsen/tmi/channel/channel_message.dart';

mixin ClientListener {
  void onMessageReceived(ChannelMessage message);
}
