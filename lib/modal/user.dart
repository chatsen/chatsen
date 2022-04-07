import 'package:chatsen/widgets/chat_message.dart';
import 'package:flutter/material.dart';

import '../api/chatsen/chatsen.dart';
import '../api/chatsen/chatsen_user.dart';
import '../tmi/channel/channel.dart';
import '../tmi/channel/messages/channel_message_chat.dart';
import '../widgets/chat_view.dart';
import 'components/user_modal_header.dart';

// ignore: must_be_immutable
class UserModal extends StatelessWidget {
  late Future<ChatsenUser> future;
  final Channel? channel;

  UserModal({
    super.key,
    required String login,
    this.channel,
  }) {
    future = Chatsen.user(login);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ChatsenUser>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<ChatsenUser> snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView(
            shrinkWrap: true,
            children: [
              UserModalHeader(
                user: snapshot.data!,
              ),
              if (channel != null)
                SizedBox(
                  width: double.infinity,
                  height: 512.0,
                  child: ChatView(
                    channel: channel!,
                    filter: (message) {
                      if (message is! ChannelMessageChat) return false;
                      return message.message.prefix?.split('!').first == snapshot.data!.login;
                    },
                  ),
                ),
            ],
          );
        },
      );
}
