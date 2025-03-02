import 'package:chatsen/components/tile.dart';
import 'package:chatsen/components/toggle.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatsen/l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../data/settings/message_appearance.dart';
import 'components/modal_header.dart';

class MessageAppearanceModal extends StatelessWidget {
  const MessageAppearanceModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          final MessageAppearance messageAppearance = box.get('messageAppearance') as MessageAppearance;
          return ListView(
            shrinkWrap: true,
            children: [
              ModalHeader(title: AppLocalizations.of(context)!.messageAppearance),
              Tile(
                prefix: const Icon(Icons.av_timer_rounded),
                title: AppLocalizations.of(context)!.showTimestamps,
                suffix: Toggle(
                  value: messageAppearance.timestamps,
                  onChanged: (value) {
                    messageAppearance.timestamps = value;
                    messageAppearance.save();
                  },
                ),
                onTap: () {
                  messageAppearance.timestamps = !messageAppearance.timestamps;
                  messageAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.view_compact_outlined),
                title: AppLocalizations.of(context)!.compactMessages,
                suffix: Toggle(
                  value: messageAppearance.compact,
                  onChanged: (value) {
                    messageAppearance.compact = value;
                    messageAppearance.save();
                  },
                ),
                onTap: () {
                  messageAppearance.compact = !messageAppearance.compact;
                  messageAppearance.save();
                },
              ),
              Slider(
                divisions: 24,
                min: 1.0,
                max: 4.0,
                value: messageAppearance.scale,
                label: '${messageAppearance.scale}',
                onChanged: (value) {
                  messageAppearance.scale = value;
                  messageAppearance.save();
                },
              ),
            ],
          );
        },
      );
}
