import 'package:chatsen/data/user_trigger.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'user_trigger.dart';

class UserTriggersModal extends StatelessWidget {
  const UserTriggersModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('UserTriggers'),
        builder: (context, box) {
          return ListView(
            shrinkWrap: true,
            children: [
              const ModalHeader(title: 'User Triggers'),
              for (final userTrigger in box.values.cast<UserTrigger>()) ...[
                Tile(
                  onTap: () => Modal.show(
                    context: context,
                    child: UserTriggerModal(userTrigger: userTrigger),
                  ),
                  prefix: Icon(userTrigger.type == UserTriggerType.mention.index ? Icons.alternate_email_rounded : Icons.block_rounded),
                  suffix: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () => userTrigger.delete(),
                    child: const Icon(Icons.delete_forever_rounded),
                  ),
                  title: userTrigger.login,
                ),
              ],
              Tile(
                onTap: () => Modal.show(
                  context: context,
                  child: const UserTriggerModal(),
                ),
                prefix: const Icon(Icons.add_rounded),
                title: 'Create new user trigger',
              ),
            ],
          );
        },
      );
}
