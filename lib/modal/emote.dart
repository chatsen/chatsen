import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chatsen/l10n/app_localizations.dart';

import '../data/emote.dart';
import '../providers/emote_provider.dart';

class EmoteModal extends StatelessWidget {
  final Emote emote;
  late String? url;

  EmoteModal({
    super.key,
    required this.emote,
  }) {
    final emoteProvider = emote.provider as EmoteProvider;
    url = emoteProvider.emoteUrl(emote.id);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: emote.mipmap.last,
              height: 64.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emote.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(emote.provider.name),
                ],
              ),
            ),
            if (url != null)
              ElevatedButton(
                onPressed: () => launchUrl(
                  Uri.parse(url!),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(AppLocalizations.of(context)!.openInBrowser),
              ),
          ],
        ),
      );
}
