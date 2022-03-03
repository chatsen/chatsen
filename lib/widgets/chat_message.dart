import 'package:flutter/material.dart';

import '../data/emote.dart';
import '/tmi/channel/channel_message.dart';
import '/tmi/channel/messages/channel_message_chat.dart';

class ChatMessage extends StatefulWidget {
  final ChannelMessage message;
  final List<Emote> emotes;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.emotes,
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
                    text: '${(widget.message as ChannelMessageChat).message.tags['display-name']}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.primary,
                      color: ((widget.message as ChannelMessageChat).message.tags['color']?.isEmpty ?? true) ? Theme.of(context).colorScheme.primary : Color(int.parse('FF${(widget.message as ChannelMessageChat).message.tags['color']!.substring(1)}', radix: 16)),
                    ),
                  ),
                  for (final split in ((widget.message as ChannelMessageChat).message.parameters.skip(1).join(' ')).split(' ')) ...[
                    if (widget.emotes.any((e) => e.name == split))
                      WidgetSpan(
                        child: Image.network(
                          widget.emotes.firstWhere((e) => e.name == split).mipmap.last,
                          // scale: widget.emotes.firstWhere((e) => e.name == split).name == 'BetterTTV' ? 3 : 4,
                          scale: 4,
                        ),
                      ),
                    if (!widget.emotes.any((e) => e.name == split))
                      TextSpan(
                        text: '$split ',
                      ),
                  ],
                ],
              ),
            ),
          ),
        )
      : Container();
}
