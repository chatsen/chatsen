import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/separator.dart';
import '../data/custom_command.dart';

class CustomCommandModal extends StatefulWidget {
  final CustomCommand? customCommand;

  const CustomCommandModal({
    this.customCommand,
    super.key,
  });

  @override
  State<CustomCommandModal> createState() => _CustomCommandModalState();
}

class _CustomCommandModalState extends State<CustomCommandModal> {
  TextEditingController triggerController = TextEditingController();
  TextEditingController commandController = TextEditingController();

  @override
  void initState() {
    triggerController.text = widget.customCommand?.trigger ?? '';
    commandController.text = widget.customCommand?.command ?? '';
    super.initState();
  }

  @override
  void dispose() {
    triggerController.dispose();
    commandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
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
                  'Custom Command',
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
          TextField(
            controller: triggerController,
            decoration: const InputDecoration(
              labelText: 'Trigger',
            ),
            onChanged: (text) => setState(() {}),
          ),
          TextField(
            controller: commandController,
            decoration: const InputDecoration(
              labelText: 'Command',
            ),
            onChanged: (text) => setState(() {}),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32.0,
                child: Separator(axis: Axis.vertical),
              ),
              Expanded(
                child: InkWell(
                  onTap: (triggerController.text.isEmpty || commandController.text.isEmpty)
                      ? null
                      : () async {
                          Navigator.of(context).pop();

                          triggerController.text = triggerController.text.trim();
                          commandController.text = commandController.text.trim();

                          final customCommandsBox = Hive.box('CustomCommands');
                          if (widget.customCommand == null) {
                            customCommandsBox.add(
                              CustomCommand(
                                trigger: triggerController.text,
                                command: commandController.text,
                              ),
                            );
                          } else {
                            widget.customCommand!.trigger = triggerController.text;
                            widget.customCommand!.command = commandController.text;
                            await widget.customCommand!.save();
                          }

                          // Modal.show(
                          //   context: context,
                          //   child: VerifyTokenModal(
                          //     token: controller.text,
                          //     cookies: null,
                          //   ),
                          // );
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: (triggerController.text.isEmpty || commandController.text.isEmpty) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // for (final customCommand in box.values.cast<CustomCommand>()) ...[
          //   Text(
          //     '${customCommand.trigger}',
          //   ),
          //   Text(
          //     '${customCommand.command}',
          //   ),
          // ],
        ],
      );
}
