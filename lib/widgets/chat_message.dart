import 'package:chatsen/data/inline_url.dart';
import 'package:chatsen/modal/emote.dart';
import 'package:chatsen/modal/user.dart';
import 'package:chatsen/tmi/channel/messages/channel_message_embeds.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/modal.dart';
import '../components/surface.dart';
import '../data/emote.dart';
import '../data/settings/message_appearance.dart';
import '../modal/message.dart';
import '../tmi/channel/messages/channel_message_ban.dart';
import '../tmi/channel/messages/channel_message_notice.dart';
import '../tmi/channel/messages/embeds/file_embed.dart';
import '../tmi/channel/messages/embeds/image_embed.dart';
import '/tmi/channel/channel_message.dart';
import '/tmi/channel/messages/channel_message_chat.dart';
import 'channel_view.dart';
import 'chat/chat_ban_chip.dart';
import 'chat/chat_notice_chip.dart';
import 'chat/reply_painter.dart';
import 'embeds/embedded_file.dart';
import 'embeds/embedded_image.dart';

class BlockedChatMessage extends StatefulWidget {
  final Widget widget;
  final MessageAppearance messageAppearance;

  const BlockedChatMessage({
    super.key,
    required this.widget,
    required this.messageAppearance,
  });

  @override
  State<BlockedChatMessage> createState() => _BlockedChatMessageState();
}

class _BlockedChatMessageState extends State<BlockedChatMessage> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (widget.messageAppearance.compact ? 1.0 : 2.0)),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Blocked message '),
                    TextSpan(
                      text: hidden ? 'Show message' : 'Hide message',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // recognizer: TapGestureRecognizer()
                      //   ..onTap = () => setState
                    ),
                  ],
                ),
                style: TextStyle(fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * widget.messageAppearance.scale),
              ),
            ),
            if (!hidden) widget.widget,
          ],
        ),
        onTap: () => setState(() => hidden = !hidden),
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final ChannelMessage message;
  late MessageAppearance messageAppearance;

  ChatMessage({
    super.key,
    required this.message,
  }) {
    messageAppearance = Hive.box('Settings').get('messageAppearance');
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          if (message is ChannelMessageChat) {
            final chatMessage = message as ChannelMessageChat;
            if (chatMessage.subInfo != null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Surface(
                      type: SurfaceType.tertiary,
                      borderRadius: BorderRadius.circular(18.0 * messageAppearance.scale),
                      onTap: () async {},
                      onLongPress: () => Modal.show(
                        context: context,
                        child: MessageModal(
                          message: chatMessage,
                          channelViewState: ChannelView.of(context),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0 * messageAppearance.scale, vertical: 8.0 * messageAppearance.scale),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(chatMessage.subInfo!.msgParamWasGifted ? Icons.card_giftcard_outlined : Icons.star_border_outlined, size: Theme.of(context).textTheme.titleLarge!.fontSize! * messageAppearance.scale)),
                                  WidgetSpan(child: SizedBox(height: 8.0 * messageAppearance.scale, width: 8.0 * messageAppearance.scale)),
                                  TextSpan(text: '${chatMessage.subInfo?.systemMsg.replaceAll('\\s', ' ')}'),
                                ],
                              ),
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * messageAppearance.scale),
                            ),
                            buildMessageContent(context, chatMessage, messageAppearance),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final widget = Surface(
              type: chatMessage.blocked
                  ? SurfaceType.error
                  : chatMessage.mentionned
                      ? SurfaceType.primary
                      : SurfaceType.transparent,
              onTap: () async {},
              onLongPress: () => Modal.show(
                context: context,
                child: MessageModal(
                  message: chatMessage,
                  channelViewState: ChannelView.of(context),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
                child: buildMessageContent(context, chatMessage, messageAppearance),
              ),
            );
            if (chatMessage.blocked) {
              return BlockedChatMessage(
                widget: widget,
                messageAppearance: messageAppearance,
              );
            }

            return widget;
          } else if (message is ChannelMessageBan) {
            return ChatBanChip(messageAppearance: messageAppearance, message: message as ChannelMessageBan);
          } else if (message is ChannelMessageNotice) {
            return ChatNoticeChip(messageAppearance: messageAppearance, message: message as ChannelMessageNotice);
          }
          return Text('Unknown message type: ${message.runtimeType}');
        },
      );

  static Widget buildMessageContent(BuildContext context, ChannelMessageChat message, MessageAppearance messageAppearance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.replyInfo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                if (messageAppearance.timestamps) SizedBox(width: 8.0 * messageAppearance.scale),
                CustomPaint(
                  painter: ReplyPainter(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2.0 * messageAppearance.scale,
                  ),
                  child: SizedBox(
                    height: 15.0 * messageAppearance.scale,
                    width: 30.0 * messageAppearance.scale,
                  ),
                ),
                SizedBox(width: 8.0 * messageAppearance.scale),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '@${message.replyInfo?.replyParentDisplayName}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${message.replyInfo?.replyParentMsgBody.replaceAll('\\s', ' ')}'),
                        // TextSpan(text: '${message.replyInfo?.replyParentMsgBody}'),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Text.rich(
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
              for (final badge in message.badges)
                WidgetSpan(
                  child: Tooltip(
                    message: badge.name,
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.0 * messageAppearance.scale),
                      child: badge.mipmap.last.endsWith('.svg')
                          ? SvgPicture.network(
                              badge.mipmap.last,
                              height: 20.0 * messageAppearance.scale,
                            )
                          : Image.network(
                              badge.mipmap.last,
                              height: 20.0 * messageAppearance.scale,
                              // scale: (1.0 / messageAppearance.scale) * 4.0,
                            ),
                    ),
                  ),
                ),
              TextSpan(
                text: '${message.user.displayName}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                  color: message.user.color ?? Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Modal.show(
                      context: context,
                      child: UserModal(
                        login: message.message.prefix!.split('!').first,
                        channel: message.channel,
                      ),
                    );
                  },
              ),
              for (final split in message.splits) ...[
                if (split is String)
                  TextSpan(
                    text: '$split ',
                    style: TextStyle(
                      fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                    ),
                  ),
                if (split is Emote)
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => Modal.show(context: context, child: EmoteModal(emote: split)),
                      child: Tooltip(
                        message: split.name,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0) * messageAppearance.scale,
                          child: Image.network(
                            split.mipmap.last,
                            scale: (1.0 / messageAppearance.scale) * 4.0,
                            height: split.provider.name == 'Emoji' ? 24.0 : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (split is InlineUrl)
                  TextSpan(
                    text: '${split.url} ',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(
                            Uri.parse(split.url),
                            mode: LaunchMode.externalApplication,
                          ),
                  ),
              ],
            ],
          ),
        ),
        if (message is ChannelMessageEmbeds)
          BlocBuilder<ChannelMessageEmbedsCubit, List<dynamic>>(
            bloc: message.embeds,
            builder: (BuildContext context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.isNotEmpty) SizedBox(height: 8.0 * messageAppearance.scale),
                for (final embed in state) ...[
                  if (embed is ImageEmbed) EmbeddedImage(embed: embed, scale: messageAppearance.scale),
                  // if (embed is VideoEmbed) EmbeddedVideo(embed: embed, scale: messageAppearance.scale),
                  if (embed is FileEmbed) EmbeddedFile(embed: embed, scale: messageAppearance.scale),
                  SizedBox(height: 8.0 * messageAppearance.scale),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/*
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

WidgetSpan(
                        child: Builder(builder: (context) {
                          final text = Text(
                            '${(message as ChannelMessageChat).user.displayName}: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                              color: (message as ChannelMessageChat).user.color ?? Theme.of(context).colorScheme.primary,
                            ),
                          );

                          return true || (message as ChannelMessageChat).user.id == '100221397'
                              ? ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      transform: GradientRotation(45.0 * 3.1415 / 180.0),
                                      colors: <Color>[
                                        Color.fromARGB(255, 147, 197, 253),
                                        Color.fromARGB(255, 187, 247, 208),
                                        Color.fromARGB(255, 253, 224, 71),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: text,
                                )
                              : text;
                        }),
                      ),


                                                // foreground: Paint()
                          //   ..shader = const LinearGradient(
                          //     transform: GradientRotation(180.0 * 3.1415 / 180.0),
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     colors: <Color>[
                          //       Color.fromARGB(255, 147, 197, 253),
                          //       Color.fromARGB(255, 187, 247, 208),
                          //       Color.fromARGB(255, 253, 224, 71),
                          //     ],
                          //   ).createShader(Rect.fromLTWH(
                          //     0.0,
                          //     0.0,
                          //     _textSize(
                          //         '${(message as ChannelMessageChat).user.displayName}: ',
                          //         TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                          //         )).width,
                          //     _textSize(
                          //         '${(message as ChannelMessageChat).user.displayName}: ',
                          //         TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                          //         )).height,
                          //   )),
*/
