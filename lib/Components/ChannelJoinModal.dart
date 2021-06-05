import 'package:flutter/material.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

/// [ChannelJoinModal] is our modal view/widget designed to add and join new channels to the client.
class ChannelJoinModal extends StatefulWidget {
  final twitch.Client? client;
  final Function refresh;

  const ChannelJoinModal({
    Key? key,
    required this.client,
    required this.refresh,
  }) : super(key: key);

  @override
  _ChannelJoinModalState createState() => _ChannelJoinModalState();
}

class _ChannelJoinModalState extends State<ChannelJoinModal> {
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
    var channelNames = textEditingController!.text.replaceAll(' ', ',').split(',').map((value) => '#$value').toList();
    channelNames.removeWhere((channelName) => widget.client!.channels.any((channel) => channel.name == channelName));
    await widget.client!.joinChannels(channelNames);
    var channelsBox = await Hive.openBox('Channels');
    channelsBox.clear();
    channelsBox.addAll(widget.client!.channels.map((channel) => channel.name));
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
                          hintText: 'Channel names to join',
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
