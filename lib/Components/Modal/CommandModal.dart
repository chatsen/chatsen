import 'dart:convert';

import 'package:chatsen/Commands/Command.dart';
import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class CommandModal extends StatefulWidget {
  final Command command;

  const CommandModal({
    Key? key,
    required this.command,
  }) : super(key: key);

  @override
  State<CommandModal> createState() => _CommandModalState();

  static Future<void> show(
    BuildContext context, {
    required Command command,
  }) async {
    await BlurModal.show(
      context: context,
      child: CommandModal(
        command: command,
      ),
    );
  }
}

class _CommandModalState extends State<CommandModal> {
  late TextEditingController triggerController;
  late TextEditingController commandController;

  @override
  void initState() {
    triggerController = TextEditingController(text: widget.command.trigger);
    commandController = TextEditingController(text: widget.command.command);
    super.initState();
  }

  @override
  void dispose() {
    triggerController.dispose();
    commandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: triggerController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Trigger',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: commandController,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Command',
                ),
              ),
            ],
          ),
        ),
      );
}
