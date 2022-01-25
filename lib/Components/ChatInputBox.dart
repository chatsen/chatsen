import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatsen/Commands/CommandsCubit.dart';
import 'package:chatsen/Settings/Settings.dart';
import 'package:chatsen/Settings/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/Components/EmoteListModal.dart';
import 'Modal/UploadModal.dart';
import 'UI/NetworkImageWrapper.dart';
import 'WidgetTooltip.dart';
import 'package:collection/collection.dart';

/// [ChatInputBox] is our widget that features the input field used for every channel. It's feature rich and even contains autocompletion features!
class ChatInputBox extends StatefulWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;

  const ChatInputBox({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  @override
  ChatInputBoxState createState() => ChatInputBoxState();
}

class ChatInputBoxState extends State<ChatInputBox> {
  GlobalKey key = GlobalKey();
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? timer;

  void appendText(String str) {
    setState(() {
      textEditingController.text = '${textEditingController.text}${textEditingController.text.isNotEmpty ? ' ' : ''}$str';
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  List<Widget> getAutoCompletionItems() => [
        if (textEditingController.text.split(' ').last.length >= 2 && !textEditingController.text.endsWith(' '))
          for (var emote in widget.client!.emotes + widget.channel!.emotes + widget.channel!.transmitter!.emotes + widget.client!.emojis)
            if ('${false ? ':' : ''}${emote.name}'.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase()) && (false ? textEditingController.text.startsWith(':') : true))
              WidgetTooltip(
                // message: '${emote.name}',
                message: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: NetworkImageW(
                          emote.mipmap!.last!,
                          height: 96.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(emote.name!),
                      Text(emote.provider!),
                    ],
                  ),
                ),

                child: InkWell(
                  onTap: () async {
                    List<String?> splits = textEditingController.text.split(' ');
                    splits.last = (emote.alt ?? emote.name); // emote.name;
                    textEditingController.text = splits.join(' ') + ' ';
                    textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                    focusNode.requestFocus();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 32.0,
                      child: NetworkImageW(emote.mipmap!.last!),
                    ),
                  ),
                ),
              ),
      ];

  void send(String text, {bool remove = true}) {
    text = text.trim();

    // Command parser
    var firstCommand = BlocProvider.of<CommandsCubit>(context).state.firstWhereOrNull((command) => text.startsWith(command.trigger));
    if (firstCommand != null) {
      var textSplits = text.substring(firstCommand.trigger.length).split(' ');
      text = firstCommand.command;
      text = text.replaceAllMapped(
        RegExp(r'{\d*}'),
        (match) {
          var matchText = match.group(0) ?? '{}';
          var matchContent = matchText.substring(1, matchText.length - 1);
          var index = int.tryParse(matchContent);
          if (index != null && index < textSplits.length && index > 0) {
            return textSplits[index];
          }
          return '';
        },
      );
      text = text.replaceAllMapped(
        RegExp(r'{\d*\+}'),
        (match) {
          var matchText = match.group(0) ?? '{+}';
          var matchContent = matchText.substring(1, matchText.length - 2);
          var index = int.tryParse(matchContent);
          if (index != null && index < textSplits.length && index > 0) {
            return textSplits.skip(index).join(' ');
          }
          return '';
        },
      );
    }

    widget.channel?.send(text);
    if (remove) textEditingController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var autocompletionItems = getAutoCompletionItems();
    var autocompletionItemsUsers = getAutoCompletionUsers();
    var autocompletionCommands = getAutoCompletionCommands();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1.0,
          color: Theme.of(context).dividerColor,
        ),
        Padding(
          // MediaQuery.of(context).padding.
          padding: EdgeInsets.only(left: MediaQuery.of(context).padding.left, right: MediaQuery.of(context).padding.right),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (kDebugMode || widget.channel?.transmitter?.credentials?.token != null) ...[
                if (autocompletionCommands.isNotEmpty)
                  Container(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: autocompletionCommands,
                    ),
                  ),
                if (autocompletionItemsUsers.isNotEmpty)
                  Container(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: autocompletionItemsUsers,
                    ),
                  ),
                if (autocompletionItems.isNotEmpty)
                  Container(
                    height: 56.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: autocompletionItems,
                    ),
                  ),
                Container(
                  // height: 64.0,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: textEditingController.text.isEmpty ? 1 : null,
                          maxLength: 498,
                          key: key,
                          focusNode: focusNode,
                          controller: textEditingController,
                          autofocus: false,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            filled: false,
                            isDense: true,
                            hintText: 'Message ${widget.channel!.name} as ${widget.channel!.transmitter!.credentials!.login}',
                            counterText: '',
                            // helperText: 'follow(420m)',
                            border: InputBorder.none,
                          ),
                          onChanged: (text) async => setState(() {}),
                          onSubmitted: send,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: InkWell(
                          onTap: () async {
                            await UploadModal.show(
                              context,
                              channel: widget.channel!,
                            );
                          },
                          child: Icon(
                            (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.photo_fill : Icons.file_present,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                          ),
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: EmoteListModal(
                                    client: widget.client,
                                    channel: widget.channel,
                                    insertEmote: (emote) {
                                      var splits = textEditingController.text.split(' ');
                                      splits.last = emote!;
                                      textEditingController.text = splits.join(' ') + ' ';
                                      textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                                      focusNode.requestFocus();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              // backgroundColor: Colors.transparent,
                            );
                          },
                          child: Icon(
                            (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.smiley : Icons.emoji_emotions_outlined,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                          ),
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapDown: (e) {
                            timer?.cancel();
                            timer = null;
                            timer = Timer.periodic(
                              Duration(seconds: 2),
                              (timer) {
                                send(textEditingController.text, remove: false);
                              },
                            );
                          },
                          onTapCancel: () {
                            timer?.cancel();
                            timer = null;
                          },
                          onTapUp: (e) {
                            timer?.cancel();
                            timer = null;
                          },
                          child: InkWell(
                            onTap: () => send(textEditingController.text),
                            child: Icon(
                              (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.arrow_right_circle : Icons.send,
                              color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getAutoCompletionUsers() {
    final startsWithAt = textEditingController.text.split(' ').last.toLowerCase().startsWith('@');
    return [
      if (textEditingController.text.split(' ').last.length >= 2 && !textEditingController.text.endsWith(' '))
        for (var user in widget.channel!.users.values.expand((element) => element))
          if ('${startsWithAt ? '@' : ''}$user'.toLowerCase().contains(textEditingController.text.split(' ').last.toLowerCase()) && (startsWithAt ? textEditingController.text.startsWith('@') : true))
            InkWell(
              onTap: () async {
                var settings = BlocProvider.of<Settings>(context).state as SettingsLoaded;
                var splits = textEditingController.text.split(' ');
                splits.last = ((settings.mentionWithAt || startsWithAt) ? '@' : '') + user;
                textEditingController.text = splits.join(' ') + ' ';
                textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                focusNode.requestFocus();
                setState(() {});
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(user),
                ),
              ),
            ),
    ];
  }

  List<Widget> getAutoCompletionCommands() => [
        if (textEditingController.text.split(' ').last.isNotEmpty && !textEditingController.text.endsWith(' '))
          for (var cmd in BlocProvider.of<CommandsCubit>(context).state.where((command) => command.trigger.toLowerCase().startsWith(textEditingController.text.toLowerCase())))
            InkWell(
              onTap: () async {
                var splits = textEditingController.text.split(' ');
                splits.last = cmd.trigger;
                textEditingController.text = splits.join(' ') + ' ';
                textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                focusNode.requestFocus();
                setState(() {});
              },
              child: WidgetTooltip(
                message: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cmd.trigger, style: Theme.of(context).textTheme.headline5),
                      Text(cmd.command),
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(cmd.trigger),
                  ),
                ),
              ),
            ),
      ];
}
