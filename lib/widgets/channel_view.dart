import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../api/catbox/catbox.dart';
import '../tmi/channel/channel.dart';
import 'chat_view.dart';

class ChannelView extends StatefulWidget {
  final Channel channel;

  const ChannelView({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  final TextEditingController textEditingController = TextEditingController();
  bool spamming = false;
  bool emoteKeyboard = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ChatView(
              channel: widget.channel,
            ),
          ),
          Material(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textEditingController.text.split(' ').last.length >= 2 && (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state).any((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
                    Ink(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: SizedBox(
                        height: 32.0 + 24.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final emote in (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state).where((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
                              Tooltip(
                                message: emote.name,
                                child: InkWell(
                                  onTap: () {
                                    final splits = textEditingController.text.split(' ');
                                    splits.removeLast();
                                    splits.add('${emote.name} ');
                                    textEditingController.text = splits.join(' ');
                                    textEditingController.selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: textEditingController.text.length,
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network(
                                      emote.mipmap.last,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if (emoteKeyboard)
                    SizedBox(
                      height: 200.0,
                      child: GridView.extent(
                        padding: MediaQuery.of(context).padding.copyWith(top: 0.0, bottom: 0.0),
                        maxCrossAxisExtent: 32.0 + 24.0,
                        children: [
                          for (final emote in (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state))
                            Tooltip(
                              message: emote.name,
                              child: InkWell(
                                onTap: () {
                                  textEditingController.text = (textEditingController.text.split(' ') + [emote.name]).where((element) => element.isNotEmpty).join(' ') + ' ';
                                  textEditingController.selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset: textEditingController.text.length,
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.network(
                                    emote.mipmap.last,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final picker = await FilePicker.platform.pickFiles();
                          final splits = textEditingController.text.split(' ');
                          for (PlatformFile file in picker?.files ?? []) {
                            final uploadedFile = await Catbox.uploadFile(file.name, File(file.path!).readAsBytesSync());
                            splits.add(uploadedFile.url);
                          }
                          splits.removeWhere((element) => element.isEmpty);
                          if (splits.isNotEmpty) textEditingController.text = splits.join(' ') + ' ';
                        },
                        child: SizedBox(
                          width: 48.0,
                          height: 48.0,
                          child: Icon(
                            Icons.photo_size_select_actual_outlined,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 12.0),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            hintText: 'Send message in ${widget.channel.name}',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) {
                            widget.channel.send(text);
                            textEditingController.clear();
                          },
                          onChanged: (text) {
                            setState(() {});
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            emoteKeyboard = !emoteKeyboard;
                          });
                        },
                        child: SizedBox(
                          width: 48.0,
                          height: 48.0,
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.channel.send(textEditingController.text);
                          textEditingController.clear();
                        },
                        onLongPress: () {
                          setState(() {
                            spamming = !spamming;
                          });
                        },
                        child: SizedBox(
                          width: 48.0,
                          height: 48.0,
                          child: Icon(
                            spamming ? Icons.send_and_archive_outlined : Icons.send_outlined,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
