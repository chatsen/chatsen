import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/tile.dart';
import '../components/toggle.dart';
import '/data/settings/chat_settings.dart';
import 'components/modal_header.dart';

class ChatSettingsModal extends StatelessWidget {
  const ChatSettingsModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          final ChatSettings chatSettings = box.get('chatSettings') as ChatSettings;
          return ListView(
            shrinkWrap: true,
            children: [
              ModalHeader(title: AppLocalizations.of(context)!.chatSettings),
              Tile(
                title: AppLocalizations.of(context)!.autocompleteUsersWithAt,
                prefix: const Icon(Icons.alternate_email_outlined),
                suffix: Toggle(
                  value: chatSettings.userAutocompletionWithAt,
                  onChanged: (newValue) {
                    chatSettings.userAutocompletionWithAt = !chatSettings.userAutocompletionWithAt;
                    chatSettings.save();
                  },
                ),
                onTap: () {
                  chatSettings.userAutocompletionWithAt = !chatSettings.userAutocompletionWithAt;
                  chatSettings.save();
                },
              ),
              Tile(
                title: AppLocalizations.of(context)!.autocompleteEmotesWithColon,
                prefix: const Icon(Icons.emoji_emotions_outlined),
                suffix: Toggle(
                  value: chatSettings.emoteAutocompletionWithColon,
                  onChanged: (newValue) {
                    chatSettings.emoteAutocompletionWithColon = !chatSettings.emoteAutocompletionWithColon;
                    chatSettings.save();
                  },
                ),
                onTap: () {
                  chatSettings.emoteAutocompletionWithColon = !chatSettings.emoteAutocompletionWithColon;
                  chatSettings.save();
                },
              ),
            ],
          );
        },
      );
}
