import 'dart:io';
import 'dart:typed_data';

import 'package:chatsen/api/catbox/catbox.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tmi/channel/channel_message.dart';
import 'chat_message.dart';
import '/tmi/channel/channel.dart';
import '/tmi/channel/channel_messages.dart';

class ChatView extends StatefulWidget {
  final Channel channel;

  const ChatView({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController textEditingController = TextEditingController();
  bool spamming = false;
  bool emoteKeyboard = false;

  ScrollController scrollController = ScrollController();
  List<ChannelMessage>? scrollMessages;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ChannelMessages, List<ChannelMessage>>(
        bloc: widget.channel.channelMessages,
        buildWhen: (state1, state2) => scrollMessages == null,
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification && scrollMessages == null && scrollController.position.pixels > scrollController.position.minScrollExtent) {
                    scrollMessages = state;
                    setState(() {});
                  }
                  if (scrollNotification is ScrollEndNotification && scrollMessages != null && scrollController.position.pixels <= scrollController.position.minScrollExtent) {
                    scrollMessages = null;
                    setState(() {});
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: MediaQuery.of(context).padding.copyWith(
                        bottom: 8.0,
                      ),
                  reverse: true,
                  itemCount: (scrollMessages ?? state).length,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) => ChatMessage(
                    key: ObjectKey((scrollMessages ?? state).reversed.elementAt(index)),
                    message: (scrollMessages ?? state).reversed.elementAt(index),
                  ),
                ),
              ),
            ),
            Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (scrollMessages != null)
                      Ink(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        height: 32.0 + 24.0,
                        child: InkWell(
                          onTap: () {
                            scrollMessages = null;
                            setState(() {});
                            WidgetsBinding.instance.scheduleFrameCallback((_) {
                              scrollController.jumpTo(scrollController.position.minScrollExtent);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward_rounded,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'Scroll to bottom',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
        ),
      );
}
