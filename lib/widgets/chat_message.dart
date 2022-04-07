import 'package:chatsen/modal/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/modal.dart';
import '../data/emote.dart';
import '../data/settings/message_appearance.dart';
import '/tmi/channel/channel_message.dart';
import '/tmi/channel/messages/channel_message_chat.dart';

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final ChannelMessage message;
  late MessageAppearance messageAppearance;

  ChatMessage({
    Key? key,
    required this.message,
  }) : super(key: key) {
    messageAppearance = Hive.box('Settings').get('messageAppearance');
  }

  @override
  Widget build(BuildContext context) => message is ChannelMessageChat
      ? InkWell(
          onTap: () async {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
            child: Text.rich(
              TextSpan(
                children: [
                  if (messageAppearance.timestamps)
                    TextSpan(
                      text: '${message.dateTime.hour}:${message.dateTime.minute.toString().padLeft(2, '0')}  ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                      ),
                    ),
                  for (final badge in (message as ChannelMessageChat).badges)
                    WidgetSpan(
                      child: Tooltip(
                        message: badge.name,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.network(
                            badge.mipmap.last,
                            scale: (1.0 / messageAppearance.scale) * 4.0,
                          ),
                        ),
                      ),
                    ),
                  TextSpan(
                    text: '${(message as ChannelMessageChat).message.tags['display-name']}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                      color: ((message as ChannelMessageChat).message.tags['color']?.isEmpty ?? true) ? Theme.of(context).colorScheme.primary : Color(int.parse('FF${(message as ChannelMessageChat).message.tags['color']!.substring(1)}', radix: 16)),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Modal.show(
                          context: context,
                          child: UserModal(
                            login: (message as ChannelMessageChat).message.prefix!.split('!').first,
                            channel: message.channel,
                          ),
                        );
                      },
                  ),
                  for (final split in (message as ChannelMessageChat).splits) ...[
                    if (split is String)
                      TextSpan(
                        text: '$split ',
                        style: TextStyle(
                          fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                        ),
                      ),
                    if (split is Emote)
                      WidgetSpan(
                        child: Tooltip(
                          message: split.name,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.network(
                              split.mipmap.last,
                              scale: (1.0 / messageAppearance.scale) * 4.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        )
      : Container();
}
