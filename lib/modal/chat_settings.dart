import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
import '../components/tile.dart';
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
                prefix: const Icon(Icons.supervised_user_circle_outlined),
                title: AppLocalizations.of(context)!.autocompleteUsersWith,
                suffix: const Icon(Icons.more_vert_outlined),
                onTap: () {
                  Modal.show(
                    context: context,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ModalHeader(title: AppLocalizations.of(context)!.autocompleteUsersWith),
                        Tile(
                          title: 'Nothing',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.nothing.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                        Tile(
                          title: '@',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.character.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                        Tile(
                          title: 'Both',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.both.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Tile(
                prefix: const Icon(Icons.emoji_emotions_outlined),
                title: AppLocalizations.of(context)!.autocompleteEmotesWith,
                suffix: const Icon(Icons.more_vert_outlined),
                onTap: () {
                  Modal.show(
                    context: context,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ModalHeader(title: AppLocalizations.of(context)!.autocompleteEmotesWith),
                        Tile(
                          title: 'Nothing',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.nothing.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                        Tile(
                          title: ':',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.character.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                        Tile(
                          title: 'Both',
                          onTap: () {
                            chatSettings.userAutocompletion = ChatSettingsAutocompletionInput.both.index;
                            chatSettings.save();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
}
