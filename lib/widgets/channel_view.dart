import 'dart:io';

import 'package:chatsen/widgets/chat_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/catbox/catbox.dart';
import '../components/surface.dart';
import '../components/tile.dart';
import '../data/custom_command.dart';
import '../tmi/channel/channel.dart';
import '../tmi/channel/messages/channel_message_chat.dart';
import 'chat_view.dart';

class ChannelView extends StatefulWidget {
  final Channel channel;

  const ChannelView({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelView> createState() => ChannelViewState();

  static ChannelViewState? of(BuildContext context) => context.findAncestorStateOfType<ChannelViewState>();
}

enum AutocompletionType {
  emote,
  customCommand,
}

class AutocompletionItem {
  final Widget? prefix;
  final String title;
  final String? subtitle;
  final Function()? onTap;
  final Function()? onLongPress;
  final Widget? shortened;
  final AutocompletionType type;

  AutocompletionItem({
    this.prefix,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.shortened,
    required this.type,
  });
}

class ChannelViewState extends State<ChannelView> {
  final TextEditingController textEditingController = TextEditingController();
  bool spamming = false;
  bool emoteKeyboard = false;
  ChannelMessageChat? replyChannelMessageChat;

  void setReplyChannelMessageChat(ChannelMessageChat? channelMessageChat) {
    setState(() {
      replyChannelMessageChat = channelMessageChat;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<AutocompletionItem> getAutocompletionItems() {
    if (textEditingController.text.split(' ').last.length < 2) return [];
    final matchingEmotes = (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state).where((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase()));
    return [
      for (final customCommand in Hive.box('CustomCommands').values.cast<CustomCommand>())
        AutocompletionItem(
          type: AutocompletionType.customCommand,
          prefix: Icon(Icons.keyboard_command_key_rounded),
          shortened: Text(customCommand.trigger),
          title: customCommand.trigger,
          subtitle: customCommand.command,
          onTap: () {
            // final splits = textEditingController.text.split(' ');
            // splits.removeLast();
            // splits.add('${emote.code ?? emote.name} ');
            // textEditingController.text = splits.join(' ');
            // textEditingController.selection = TextSelection.fromPosition(
            //   TextPosition(
            //     offset: textEditingController.text.length,
            //   ),
            // );
            // setState(() {});
          },
        ),
      for (final emote in matchingEmotes)
        AutocompletionItem(
          type: AutocompletionType.emote,
          prefix: Image.network(emote.mipmap.last, width: 24.0, height: 24.0),
          shortened: Image.network(emote.mipmap.last, width: 24.0, height: 24.0),
          title: emote.name,
          subtitle: emote.provider.name,
          onTap: () {
            final splits = textEditingController.text.split(' ');
            splits.removeLast();
            splits.add('${emote.code ?? emote.name} ');
            textEditingController.text = splits.join(' ');
            textEditingController.selection = TextSelection.fromPosition(
              TextPosition(
                offset: textEditingController.text.length,
              ),
            );
            setState(() {});
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ChatView(
              padding: MediaQuery.of(context).viewPadding,
              channel: widget.channel,
            ),
            // child: Container(),
          ),
          Material(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (replyChannelMessageChat != null)
                    Surface(
                      type: SurfaceType.error,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (true ? 1.0 : 2.0)),
                                  child: Text('@ Replying to'),
                                ),
                                ChatMessage(message: replyChannelMessageChat!),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Surface(
                              onTap: () => setReplyChannelMessageChat(null),
                              borderRadius: BorderRadius.circular(40.0),
                              // type: SurfaceType.error,
                              child: const Icon(Icons.close_outlined),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                        ],
                      ),
                    ),
                  Surface(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 56.0 * 4.5),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        children: [
                          for (final autocompletionItem in getAutocompletionItems())
                            Tile(
                              onTap: autocompletionItem.onTap,
                              onLongPress: autocompletionItem.onLongPress,
                              prefix: autocompletionItem.prefix,
                              title: autocompletionItem.title,
                              subtitle: autocompletionItem.subtitle,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Surface(
                    type: SurfaceType.tertiary,
                    child: SizedBox(
                      height: 56.0,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final autocompletionItem in getAutocompletionItems())
                            InkWell(
                              onTap: autocompletionItem.onTap,
                              onLongPress: autocompletionItem.onLongPress,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: 56.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: autocompletionItem.shortened,
                                ),
                              ),
                              // title: autocompletionItem.title,
                              // subtitle: autocompletionItem.subtitle,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // if (textEditingController.text.split(' ').last.length >= 2 && (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state).any((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
                  //   Ink(
                  //     color: Theme.of(context).colorScheme.secondaryContainer,
                  //     child: SizedBox(
                  //       height: 32.0 + 24.0,
                  //       child: ListView(
                  //         scrollDirection: Axis.horizontal,
                  //         children: [
                  //           for (final emote in (widget.channel.channelEmotes.state + widget.channel.client.globalEmotes.state).where((emote) => emote.name.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase())))
                  //             Tooltip(
                  //               message: emote.name,
                  //               child: InkWell(
                  //                 onTap: () {
                  //                   final splits = textEditingController.text.split(' ');
                  //                   splits.removeLast();
                  //                   splits.add('${emote.code ?? emote.name} ');
                  //                   textEditingController.text = splits.join(' ');
                  //                   textEditingController.selection = TextSelection.fromPosition(
                  //                     TextPosition(
                  //                       offset: textEditingController.text.length,
                  //                     ),
                  //                   );
                  //                   setState(() {});
                  //                 },
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(12.0),
                  //                   child: Image.network(
                  //                     emote.mipmap.last,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
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
                                  textEditingController.text = (textEditingController.text.split(' ') + [emote.code ?? emote.name]).where((element) => element.isNotEmpty).join(' ') + ' ';
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
                  SizedBox(
                    height: 48.0,
                    child: Row(
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
                        // const Separator(axis: Axis.vertical),
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              hintText: AppLocalizations.of(context)!.sendMessageIn(widget.channel.name), //'Send message in ',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (text) {
                              widget.channel.send(text, tags: {
                                if (replyChannelMessageChat != null) 'reply-parent-msg-id': replyChannelMessageChat!.id,
                              });
                              setReplyChannelMessageChat(null);
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
                        // const Separator(axis: Axis.vertical),
                        InkWell(
                          onTap: () {
                            // TODO: Implement replies here
                            // TODO: Implement reactions here
                            widget.channel.send(textEditingController.text, tags: {
                              if (replyChannelMessageChat != null) 'reply-parent-msg-id': replyChannelMessageChat!.id,
                            });
                            setReplyChannelMessageChat(null);
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
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  void addSplit(String? text) {
    if (text == null) return;
    setState(() {
      var splits = textEditingController.text.split(' ');
      splits.add(text);
      splits.removeWhere((element) => element.isEmpty);
      textEditingController.text = splits.join(' ');
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: textEditingController.text.length,
        ),
      );
    });
  }
}
