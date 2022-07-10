import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/separator.dart';
import '../data/user_trigger.dart';
import 'components/modal_header.dart';

class UserTriggerModal extends StatefulWidget {
  final UserTrigger? userTrigger;

  const UserTriggerModal({
    this.userTrigger,
    super.key,
  });

  @override
  State<UserTriggerModal> createState() => _UserTriggerModalState();
}

class _UserTriggerModalState extends State<UserTriggerModal> {
  UserTriggerType type = UserTriggerType.mention;
  TextEditingController patternController = TextEditingController();

  @override
  void initState() {
    type = UserTriggerType.values[widget.userTrigger?.type ?? UserTriggerType.mention.index];
    patternController.text = widget.userTrigger?.login ?? '';
    super.initState();
  }

  @override
  void dispose() {
    patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          const ModalHeader(title: 'User Trigger'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: TextField(
              controller: patternController,
              decoration: const InputDecoration(
                labelText: 'Login',
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (text) => setState(() {}),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('Mention'),
                selected: type == UserTriggerType.mention,
                onSelected: (bool selected) => setState(() {
                  type = UserTriggerType.mention;
                }),
              ),
              ChoiceChip(
                label: const Text('Block'),
                selected: type == UserTriggerType.block,
                onSelected: (bool selected) => setState(() {
                  type = UserTriggerType.block;
                }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
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
                  onTap: patternController.text.isEmpty
                      ? null
                      : () async {
                          Navigator.of(context).pop();

                          patternController.text = patternController.text.trim();

                          final userTriggersBox = Hive.box('UserTriggers');
                          if (widget.userTrigger == null) {
                            await userTriggersBox.add(
                              UserTrigger(
                                login: patternController.text,
                                type: type.index,
                              ),
                            );
                          } else {
                            widget.userTrigger!.type = type.index;
                            widget.userTrigger!.login = patternController.text;
                            await widget.userTrigger!.save();
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: patternController.text.isEmpty ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
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
