import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:chatsen/widgets/avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
              const ModalHeader(title: 'Appearance'),
              Tile(
                prefix: const Icon(Icons.light_mode_outlined),
                title: 'Light',
                onTap: () {
                  applicationAppearance.themeMode = 'light';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.dark_mode_outlined),
                title: 'Dark',
                onTap: () {
                  applicationAppearance.themeMode = 'dark';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.phone_android_outlined),
                title: 'System',
                onTap: () {
                  applicationAppearance.themeMode = 'system';
                  applicationAppearance.save();
                },
              ),
              Tile(
                prefix: const Icon(Icons.blinds_closed_outlined),
                title: 'High Contrast (Amoled)',
                onTap: () {
                  applicationAppearance.highContrast = !applicationAppearance.highContrast;
                  applicationAppearance.save();
                },
                suffix: Switch(
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
