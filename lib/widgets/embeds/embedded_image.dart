import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../tmi/channel/messages/embeds/image_embed.dart';

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
                  onTap: () => launchUrl(
                    Uri.parse(embed.url),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
