import 'package:chatsen/data/custom_command.dart';
import 'package:chatsen/data/custom_mention.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/boxlistener.dart';
import '../components/modal.dart';
import '../components/tile.dart';
import 'components/modal_header.dart';
import 'custom_command.dart';
import 'message_mention.dart';

class CustomMentionsModal extends StatelessWidget {
  const CustomMentionsModal({super.key});

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('MessageMentions'),
        builder: (context, box) {
          return ListView(
            shrinkWrap: true,
            children: [
              const ModalHeader(title: 'Message Mentions'),
              for (final customMention in box.values.cast<CustomMention>()) ...[
                Tile(
                  onTap: () => Modal.show(
                    context: context,
                    child: CustomMentionModal(customMention: customMention),
                  ),
                  prefix: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () => customMention.delete(),
                    child: const Icon(Icons.delete_forever_rounded),
                  ),
                  title: customMention.pattern,
                ),
              ],
              Tile(
                onTap: () => Modal.show(
                  context: context,
                  child: const CustomMentionModal(),
                ),
                prefix: const Icon(Icons.add_rounded),
                title: 'Create new message mention',
              ),
            ],
          );
        },
      );
}
