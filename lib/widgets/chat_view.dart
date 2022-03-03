import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/emote.dart';
import '../tmi/channel/channel_message.dart';
import 'chat_message.dart';
import '/providers/betterttv.dart';
import '/providers/emote_provider.dart';
import '/providers/frankerfacez.dart';
import '/providers/seventv.dart';
import '/tmi/channel/channel.dart';
import '/tmi/channel/channel_messages.dart';
import '/tmi/client/client.dart';

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
  List<Emote> emotes = [];
  bool spamming = false;
  bool emoteKeyboard = false;

  Future<void> loadEmotes() async {
    for (final emoteProvider in context.read<Client>().providers.whereType<EmoteProvider>()) {
      try {
        final globalEmotes = await emoteProvider.globalEmotes();
        emotes.addAll(globalEmotes);
      } catch (e) {
        print('Couldn\'t fetch global emotes from ${emoteProvider.name}');
      }

      try {
        final channelEmotes = await emoteProvider.channelEmotes(widget.channel.id!);
        emotes.addAll(channelEmotes);
      } catch (e) {
        print('Couldn\'t fetch channel emotes from ${emoteProvider.name} for channel ${widget.channel.name}');
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    loadEmotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ChannelMessages, List<ChannelMessage>>(
        bloc: widget.channel.channelMessages,
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: MediaQuery.of(context).padding.copyWith(
                      bottom: 8.0,
                    ),
                reverse: true,
                itemCount: state.length,
                itemBuilder: (BuildContext context, int index) => ChatMessage(
                  key: ObjectKey(state.reversed.elementAt(index)),
                  message: state.reversed.elementAt(index),
                  emotes: emotes,
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
                    if (emoteKeyboard)
                      SizedBox(
                        height: 256.0,
                        child: GridView.extent(
                          padding: MediaQuery.of(context).padding.copyWith(top: 0.0, bottom: 0.0),
                          maxCrossAxisExtent: 32.0 + 24.0,
                          children: [
                            for (final emote in emotes)
                              InkWell(
                                onTap: () {
                                  // textEditingController.text = textEditingController.text + emote.code;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.network(
                                    emote.mipmap.last,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (textEditingController.text.split(' ').last.length >= 2 && emotes.any((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
                      SizedBox(
                        height: 32.0 + 24.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final emote in emotes.where((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final picker = await FilePicker.platform.pickFiles();
                            final splits = textEditingController.text.split(' ');
                            for (PlatformFile file in picker?.files ?? []) {
                              splits.add('${file.path}');
                              // print(File(file.path!).readAsStringSync());
                            }
                            textEditingController.text = splits.join(' ') + ' ';
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
