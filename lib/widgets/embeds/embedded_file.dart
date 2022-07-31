import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

import '../../tmi/channel/messages/embeds/file_embed.dart';

class EmbeddedFile extends StatelessWidget {
  final FileEmbed embed;
  final double scale;

  const EmbeddedFile({
    super.key,
    required this.embed,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 128.0 * 2.5) * scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0 * scale),
            color: Colors.black,
            border: Border.all(color: Colors.grey[300]!, width: 1.0 * scale),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0) * scale,
            child: Row(
              children: [
                Icon(
                  Icons.file_copy,
                  size: 32.0 * scale,
                ),
                SizedBox(width: 8.0 * scale),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        embed.name,
                        style: TextStyle(
                          fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 14.0) * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(filesize(embed.size)),
                    ],
                  ),
                ),
                SizedBox(width: 8.0 * scale),
                Icon(
                  Icons.download_outlined,
                  size: 32.0 * scale,
                ),
              ],
            ),
          ),
        ),
      );
}
