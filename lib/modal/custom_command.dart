import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/separator.dart';
import '../data/custom_command.dart';
import 'components/modal_header.dart';

class CustomCommandModal extends StatefulWidget {
  final CustomCommand? customCommand;

  const CustomCommandModal({
    super.key,
    this.customCommand,
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
          ModalHeader(title: AppLocalizations.of(context)!.customCommand),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: TextField(
              controller: triggerController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.commandTrigger,
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (text) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: TextField(
              controller: commandController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.command,
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (text) => setState(() {}),
            ),
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
                            await customCommandsBox.add(
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
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.save,
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
        ],
      );
}
