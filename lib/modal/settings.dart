import 'package:chatsen/components/boxlistener.dart';
import 'package:chatsen/modal/application_appearance.dart';
import 'package:chatsen/modal/application_theme.dart';
import 'package:chatsen/modal/chat_settings.dart';
import 'package:chatsen/modal/credits.dart';
import 'package:chatsen/modal/language_selection.dart';
import 'package:chatsen/modal/message_appearance.dart';
import 'package:chatsen/modal/message_triggers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'custom_commands.dart';
import 'user_triggers.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          // final MessageAppearance messageAppearance = box.get('messageAppearance') as MessageAppearance;
          return ListView(
            shrinkWrap: true,
            children: [
              ModalHeader(title: AppLocalizations.of(context)!.settings),
              // const Separator(),
              Tile(
                title: AppLocalizations.of(context)!.appearance,
                prefix: const Icon(Icons.palette_outlined),
                onTap: () => Modal.show(context: context, child: const ApplicationAppearanceModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.theme,
                prefix: const Icon(Icons.palette_outlined),
                onTap: () => Modal.show(context: context, child: const ApplicationThemeModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.chatSettings,
                prefix: const Icon(Icons.text_format_outlined),
                onTap: () => Modal.show(context: context, child: const ChatSettingsModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.language,
                subtitle: LocaleNamesLocalizationsDelegate.nativeLocaleNames[AppLocalizations.supportedLocales.firstWhereOrNull((element) => element.toLanguageTag() == box.get('locale')).toString()] ?? AppLocalizations.of(context)!.systemDefault,
                prefix: const Icon(Icons.language_outlined),
                onTap: () => Modal.show(context: context, child: const LanguageSelectionModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.messageAppearance,
                prefix: const Icon(Icons.font_download_rounded),
                onTap: () => Modal.show(context: context, child: const MessageAppearanceModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.customCommands,
                prefix: const Icon(Icons.terminal_rounded),
                onTap: () => Modal.show(context: context, child: const CustomCommandsModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.messageTriggers,
                prefix: const Icon(Icons.message_rounded),
                onTap: () => Modal.show(context: context, child: const MessageTriggersModal()),
              ),
              Tile(
                title: AppLocalizations.of(context)!.userTriggers,
                prefix: const Icon(Icons.person_outline_rounded),
                onTap: () => Modal.show(context: context, child: const UserTriggersModal()),
              ),
              Tile(
                title: 'AppLocalizations.of(context)!.credits',
                prefix: const Icon(Icons.work_outline_outlined),
                onTap: () => Modal.show(context: context, child: const CreditsModal()),
              ),
              BoxSwitchTile(
                title: AppLocalizations.of(context)!.chatHistory,
                prefix: const Icon(Icons.history),
                box: box,
                boxDefault: true,
                boxKey: 'recentMessagesChatHistory',
              ),
            ],
          );
        },
      );
}
