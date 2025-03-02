import 'package:chatsen/components/tile.dart';
import 'package:chatsen/modal/components/modal_header.dart';
import 'package:flutter/material.dart';
import 'package:chatsen/l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageSelectionModal extends StatelessWidget {
  const LanguageSelectionModal({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          ModalHeader(title: AppLocalizations.of(context)!.language),
          Tile(
            title: AppLocalizations.of(context)!.justDefault, // locale.toLanguageTag(),
            subtitle: AppLocalizations.of(context)!.systemDefault,
            prefix: const Icon(Icons.phone_android_outlined),
            onTap: () => Hive.box('Settings').put('locale', null),
          ),
          for (final locale in AppLocalizations.supportedLocales)
            Tooltip(
              message: locale.toLanguageTag(),
              child: Tile(
                title: LocaleNames.of(context)!.nameOf(locale.toString()) ?? (locale.toString() == 'en_PT' ? 'English (Pirate)' : locale.toString()), // locale.toLanguageTag(),
                subtitle: LocaleNamesLocalizationsDelegate.nativeLocaleNames[locale.toString()],
                prefix: const Icon(Icons.language_outlined),
                onTap: () => Hive.box('Settings').put('locale', locale.toLanguageTag()),
              ),
            ),
        ],
      );
}
