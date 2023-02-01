import 'package:chatsen/data/message_trigger.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'message_trigger.dart';

class MessageTriggersModal extends StatelessWidget {
  const MessageTriggersModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('MessageTriggers'),
        builder: (context, box) {
          return ListView(
            shrinkWrap: true,
            children: [
              const ModalHeader(title: AppLocalizations.of(context)!.messageTriggers),
              for (final messageTrigger in box.values.cast<MessageTrigger>()) ...[
                Tile(
                  onTap: () => Modal.show(
                    context: context,
                    child: MessageTriggerModal(messageTrigger: messageTrigger),
                  ),
                  prefix: Icon(messageTrigger.type == MessageTriggerType.mention.index ? Icons.alternate_email_rounded : Icons.block_rounded),
                  suffix: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () => messageTrigger.delete(),
                    child: const Icon(Icons.delete_forever_rounded),
                  ),
                  title: messageTrigger.pattern,
                ),
              ],
              Tile(
                onTap: () => Modal.show(
                  context: context,
                  child: const MessageTriggerModal(),
                ),
                prefix: const Icon(Icons.add_rounded),
                title: AppLocalizations.of(context)!.newMessageTrigger,
              ),
            ],
          );
        },
      );
}
