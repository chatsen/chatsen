import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// ignore: implementation_imports
import 'package:chewie/src/material/material_desktop_controls.dart';
import '../../tmi/channel/messages/embeds/video_embed.dart';

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
