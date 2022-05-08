import 'dart:math';

import 'package:chatsen/data/inline_url.dart';
import 'package:chatsen/modal/user.dart';
import 'package:chatsen/tmi/channel/messages/channel_message_embeds.dart';
import 'package:chatsen/tmi/channel/messages/embeds/video_embed.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/material/material_desktop_controls.dart';

import '../components/modal.dart';
import '../data/emote.dart';
import '../data/settings/message_appearance.dart';
import '../tmi/channel/messages/embeds/image_embed.dart';
import '/tmi/channel/channel_message.dart';
import '/tmi/channel/messages/channel_message_chat.dart';

class SizeBuilder extends StatelessWidget {
  final ValueNotifier<Rect> notifier = ValueNotifier(const Rect.fromLTWH(0, 0, 0, 0));
  final Widget Function(BuildContext context, Rect paintBounds, Widget? child) builder;
  final Widget? child;

  SizeBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        notifier.value = (context.findRenderObject() as RenderBox).paintBounds;
      },
    );
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}

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

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) => message is ChannelMessageChat
      ? InkWell(
          onTap: () async {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      // WidgetSpan(
                      //   child: Builder(builder: (context) {
                      //     final text = Text(
                      //       '${(message as ChannelMessageChat).user.displayName}: ',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                      //         color: (message as ChannelMessageChat).user.color ?? Theme.of(context).colorScheme.primary,
                      //       ),
                      //     );

                      //     return true || (message as ChannelMessageChat).user.id == '100221397'
                      //         ? ShaderMask(
                      //             blendMode: BlendMode.srcIn,
                      //             shaderCallback: (Rect bounds) {
                      //               return const LinearGradient(
                      //                 transform: GradientRotation(45.0 * pi / 180.0),
                      //                 colors: <Color>[
                      //                   Color.fromARGB(255, 147, 197, 253),
                      //                   Color.fromARGB(255, 187, 247, 208),
                      //                   Color.fromARGB(255, 253, 224, 71),
                      //                 ],
                      //               ).createShader(bounds);
                      //             },
                      //             child: text,
                      //           )
                      //         : text;
                      //   }),
                      // ),
                      TextSpan(
                        text: '${(message as ChannelMessageChat).user.displayName}: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0) * messageAppearance.scale,
                          color: (message as ChannelMessageChat).user.color ?? Theme.of(context).colorScheme.primary,
                          // foreground: Paint()
                          //   ..shader = const LinearGradient(
                          //     transform: GradientRotation(180.0 * pi / 180.0),
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
                                padding: const EdgeInsets.only(right: 4.0) * messageAppearance.scale,
                                child: Image.network(
                                  split.mipmap.last,
                                  scale: (1.0 / messageAppearance.scale) * 4.0,
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
                            recognizer: TapGestureRecognizer()..onTap = () => launch(split.url),
                          ),
                      ],
                    ],
                  ),
                ),
                if (message is ChannelMessageEmbeds && (message as ChannelMessageEmbeds).embeds.isNotEmpty) ...[
                  SizedBox(height: 8.0 * messageAppearance.scale),
                  for (final embed in (message as ChannelMessageEmbeds).embeds) ...[
                    if (embed is ImageEmbed) EmbeddedImage(embed: embed, scale: messageAppearance.scale),
                    if (embed is VideoEmbed) EmbeddedVideo(embed: embed, scale: messageAppearance.scale),
                    SizedBox(height: 8.0 * messageAppearance.scale),
                  ],
                ],
              ],
            ),
          ),
        )
      : Container();
}

class EmbeddedImage extends StatelessWidget {
  final ImageEmbed embed;
  final double scale;

  const EmbeddedImage({
    super.key,
    required this.embed,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 128.0 * 2.5) * scale,
              child: Image.network(
                embed.url,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => launch(embed.url),
                ),
              ),
            ),
          ],
        ),
      );
}

class EmbeddedVideo extends StatefulWidget {
  final VideoEmbed embed;
  final double scale;

  const EmbeddedVideo({
    super.key,
    required this.embed,
    this.scale = 1,
  });

  @override
  State<EmbeddedVideo> createState() => _EmbeddedVideoState();
}

class _EmbeddedVideoState extends State<EmbeddedVideo> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.embed.url);
    controller.initialize().then((value) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Color.alphaBlend(Theme.of(context).colorScheme.onSurface.withOpacity(0.075), Theme.of(context).colorScheme.surface),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 128.0 * 2.5) * widget.scale,
              child: AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: Chewie(
                  controller: ChewieController(
                    aspectRatio: 16.0 / 9.0,
                    customControls: const MaterialDesktopControls(),
                    videoPlayerController: controller,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
