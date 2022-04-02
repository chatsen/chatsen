import 'package:flutter/material.dart';

import '../data/emote.dart';
import '/tmi/channel/channel_message.dart';
import '/tmi/channel/messages/channel_message_chat.dart';

class ChatMessage extends StatefulWidget {
  final ChannelMessage message;

  const ChatMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) => widget.message is ChannelMessageChat
      ? InkWell(
          onTap: () async {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.message.dateTime.hour}:${widget.message.dateTime.minute.toString().padLeft(2, '0')}  ',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  for (final badge in (widget.message as ChannelMessageChat).badges)
                    WidgetSpan(
                      child: Tooltip(
                        message: badge.name,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.network(
                            badge.mipmap.last,
                            scale: 4,
                          ),
                        ),
                      ),
                    ),
                  TextSpan(
                    text: '${(widget.message as ChannelMessageChat).message.tags['display-name']}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.primary,
                      color: ((widget.message as ChannelMessageChat).message.tags['color']?.isEmpty ?? true) ? Theme.of(context).colorScheme.primary : Color(int.parse('FF${(widget.message as ChannelMessageChat).message.tags['color']!.substring(1)}', radix: 16)),
                    ),
                  ),
                  for (final split in (widget.message as ChannelMessageChat).splits) ...[
                    if (split is String)
                      TextSpan(
                        text: '$split ',
                      ),
                    if (split is Emote)
                      WidgetSpan(
                        child: Tooltip(
                          message: split.name,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.network(
                              split.mipmap.last,
                              scale: 4,
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
