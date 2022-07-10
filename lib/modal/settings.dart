import 'package:chatsen/components/boxlistener.dart';
import 'package:chatsen/modal/message_triggers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'custom_commands.dart';
import 'user_triggers.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          // final MessageAppearance messageAppearance = box.get('messageAppearance') as MessageAppearance;
          return ListView(
            shrinkWrap: true,
            children: [
              const ModalHeader(title: 'Settings'),
              // const Separator(),
              // SwitchListTile.adaptive(
              //   value: messageAppearance.timestamps,
              //   onChanged: (value) {
              //     messageAppearance.timestamps = value;
              //     messageAppearance.save();
              //   },
              //   title: const Text('Show timestamps'),
              // ),
              // SwitchListTile.adaptive(
              //   value: messageAppearance.compact,
              //   onChanged: (value) {
              //     messageAppearance.compact = value;
              //     messageAppearance.save();
              //   },
              //   title: const Text('Compact messages'),
              // ),
              // Slider(
              //   divisions: 16,
              //   min: 1.0,
              //   max: 4.0,
              //   value: messageAppearance.scale,
              //   label: '${messageAppearance.scale}',
              //   onChanged: (value) {
              //     messageAppearance.scale = value;
              //     messageAppearance.save();
              //   },
              // ),
              Tile(
                title: 'Custom Commands',
                prefix: const Icon(Icons.terminal_rounded),
                onTap: () => Modal.show(context: context, child: const CustomCommandsModal()),
              ),
              Tile(
                title: 'Message Triggers',
                prefix: const Icon(Icons.message_rounded),
                onTap: () => Modal.show(context: context, child: const MessageTriggersModal()),
              ),
              Tile(
                title: 'User Triggers',
                prefix: const Icon(Icons.person_outline_rounded),
                onTap: () => Modal.show(context: context, child: const UserTriggersModal()),
              ),
              BoxSwitchTile(
                title: 'Chat history',
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
