import 'package:chatsen/data/custom_command.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatsen/l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'custom_command.dart';

class CustomCommandsModal extends StatelessWidget {
  const CustomCommandsModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('CustomCommands'),
        builder: (context, box) {
          return ListView(
            shrinkWrap: true,
            children: [
              ModalHeader(title: AppLocalizations.of(context)!.customCommands),
              for (final customCommand in box.values.cast<CustomCommand>()) ...[
                Tile(
                  onTap: () => Modal.show(
                    context: context,
                    child: CustomCommandModal(customCommand: customCommand),
                  ),
                  prefix: const Icon(Icons.keyboard_command_key_rounded),
                  suffix: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () => customCommand.delete(),
                    child: const Icon(Icons.delete_forever_rounded),
                  ),
                  title: customCommand.trigger,
                  subtitle: customCommand.command,
                ),
              ],
              Tile(
                onTap: () => Modal.show(
                  context: context,
                  child: const CustomCommandModal(),
                ),
                prefix: const Icon(Icons.add_rounded),
                title: AppLocalizations.of(context)!.newCustomCommand,
              ),
            ],
          );
        },
      );
}
