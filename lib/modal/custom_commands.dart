import 'package:chatsen/data/custom_command.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(24.0),
                      child: const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Icon(Icons.close),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Custom Commands',
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 40.0,
                      height: 40.0,
                    ),
                  ],
                ),
              ),
              for (final customCommand in box.values.cast<CustomCommand>()) ...[
                InkWell(
                  onTap: () {
                    Modal.show(
                      context: context,
                      child: CustomCommandModal(
                        customCommand: customCommand,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${customCommand.trigger}: ${customCommand.command}'),
                  ),
                ),
              ],

              InkWell(
                child: Text('Add'),
                onTap: () {
                  Modal.show(
                    context: context,
                    child: CustomCommandModal(),
                  );
                },
              ),

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
            ],
          );
        },
      );
}
