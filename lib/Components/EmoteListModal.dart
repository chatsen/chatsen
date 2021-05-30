import 'package:flutter/material.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

/// [EmoteListModal] is our modal view/widget designed to add and join new channels to the client.
class EmoteListModal extends StatefulWidget {
  final twitch.Client client;
  final twitch.Channel channel;
  final Function(String emote) insertEmote;

  const EmoteListModal({
    Key key,
    @required this.client,
    @required this.channel,
    @required this.insertEmote,
  }) : super(key: key);

  @override
  _EmoteListModalState createState() => _EmoteListModalState();
}

class _EmoteListModalState extends State<EmoteListModal> {
  TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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
                height: 90.0,
                child: GridView.extent(
                  maxCrossAxisExtent: 48.0,
                  children: [
                    for (var emote in (widget.client.emotes + widget.channel.emotes + widget.channel.transmitter.emotes).where((x) => x.name.toLowerCase().contains(textEditingController.text.toLowerCase())))
                      InkWell(
                        onTap: () => widget.insertEmote(emote.name),
                        child: Image.network(emote.mipmap.first),
                      ),
                  ],
                ),
              ),
              Container(
                height: 32.0,
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    filled: false,
                    isDense: true,
                    hintText: 'Search emotes',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) async => setState(() {}),
                ),
              ),
              Container(height: 1.0, color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      );
}
