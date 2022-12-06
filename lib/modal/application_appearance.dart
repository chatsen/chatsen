import 'package:chatsen/components/toggle.dart';
import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';

class ApplicationAppearanceModal extends StatelessWidget {
  const ApplicationAppearanceModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          final ApplicationAppearance applicationAppearance = box.get('applicationAppearance') as ApplicationAppearance;
          return ListView(
            shrinkWrap: true,
            children: [
              ModalHeader(title: AppLocalizations.of(context)!.appearance),
              Tile(
                prefix: const Icon(Icons.light_mode_outlined),
                title: AppLocalizations.of(context)!.light,
                onTap: () {
                  applicationAppearance.themeMode = 'light';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.dark_mode_outlined),
                title: AppLocalizations.of(context)!.dark,
                onTap: () {
                  applicationAppearance.themeMode = 'dark';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.phone_android_outlined),
                title: AppLocalizations.of(context)!.system,
                onTap: () {
                  applicationAppearance.themeMode = 'system';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.blinds_closed_outlined),
                title: AppLocalizations.of(context)!.highContrast,
                onTap: () {
                  applicationAppearance.highContrast = !applicationAppearance.highContrast;
                  applicationAppearance.save();
                },
                suffix: Toggle(
                  value: applicationAppearance.highContrast,
                  onChanged: (value) {
                    applicationAppearance.highContrast = value;
                    applicationAppearance.save();
                  },
                ),
              ),
            ],
          );
        },
      );
}
