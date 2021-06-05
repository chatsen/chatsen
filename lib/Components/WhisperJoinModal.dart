import 'package:flutter/material.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

/// [WhisperJoinModal] is our modal view/widget designed to add and join new channels to the client.
class WhisperJoinModal extends StatefulWidget {
  final twitch.Client? client;
  final Function refresh;

  const WhisperJoinModal({
    Key? key,
    required this.client,
    required this.refresh,
  }) : super(key: key);

  @override
  _WhisperJoinModalState createState() => _WhisperJoinModalState();
}

class _WhisperJoinModalState extends State<WhisperJoinModal> {
  TextEditingController? textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController!.dispose();
    super.dispose();
  }

  void submit() async {
    var channelNames = textEditingController!.text.replaceAll(' ', ',').split(',').map((value) => '$value').toList();
    channelNames.removeWhere((channelName) => widget.client!.channels.any((channel) => channel.name == channelName));
    for (var channelName in channelNames) widget.client!.transmitters[null]!.joinWhisper(channelName);
    Navigator.of(context).pop();
    textEditingController?.clear();
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: Material(
          color: Theme.of(context).canvasColor.withAlpha(196),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 1.0, color: Theme.of(context).dividerColor),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(width: 32.0, height: 2.0, color: Theme.of(context).dividerColor),
              ),
              Container(
                height: 32.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          filled: false,
                          isDense: true,
                          hintText: 'Whisper names to join',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) async => submit(),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        height: 32.0,
                        child: InkWell(
                          onTap: () async => submit(),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1.0, color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      );
}
