import 'package:chatsen/Upload/UploadModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/Components/EmoteListModal.dart';
import '/MVP/Presenters/AutocompletePresenter.dart';
import 'WidgetTooltip.dart';

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
  _ChatInputBoxState createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  GlobalKey key = GlobalKey();
  TextEditingController? textEditingController;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    focusNode?.dispose();
    super.dispose();
  }

  List<Widget> getAutoCompletionItems() => [
        if (textEditingController!.text.split(' ').last.length >= 2 && !textEditingController!.text.endsWith(' '))
          for (var emote in widget.client!.emotes + widget.channel!.emotes + widget.channel!.transmitter!.emotes)
            if ('${AutocompletePresenter.cache.emotePrefix! ? ':' : ''}${emote.name}'.toLowerCase().contains(textEditingController!.text.split(' ').last.toLowerCase()) && (AutocompletePresenter.cache.emotePrefix! ? textEditingController!.text.startsWith(':') : true))
              WidgetTooltip(
                // message: '${emote.name}',
                message: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Image.network(
                          emote.mipmap!.last!,
                          isAntiAlias: true,
                          filterQuality: FilterQuality.high,
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
                    List<String?> splits = textEditingController!.text.split(' ');
                    splits.last = emote.name;
                    textEditingController!.text = splits.join(' ') + ' ';
                    textEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController!.text.length));
                    focusNode.requestFocus();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 32.0,
                      child: Image.network(emote.mipmap!.last!),
                    ),
                  ),
                ),
              ),
      ];

  @override
  Widget build(BuildContext context) {
    var autocompletionItems = getAutoCompletionItems();
    var autocompletionItemsUsers = getAutoCompletionUsers();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1.0,
          color: Theme.of(context).dividerColor,
        ),
        if (autocompletionItemsUsers.isNotEmpty)
          Container(
            height: 32.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: autocompletionItemsUsers,
            ),
          ),
        if (autocompletionItems.isNotEmpty)
          Container(
            height: 48.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: autocompletionItems,
            ),
          ),
        Container(
          height: 32.0,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: key,
                  focusNode: focusNode,
                  controller: textEditingController,
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    filled: false,
                    isDense: true,
                    hintText: 'Message ${widget.channel!.name} as ${widget.channel!.transmitter!.credentials!.login}',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) async => setState(() {}),
                  onSubmitted: (text) async {
                    widget.channel?.send(text);
                    textEditingController?.clear();
                    setState(() {});
                  },
                ),
              ),
              // AspectRatio(
              //   aspectRatio: 1.0,
              //   child: Container(
              //     height: 32.0,
              //     child: InkWell(
              //       onTap: () async => await UploadModal.show(context: context),
              //       child: Icon(Icons.file_present),
              //     ),
              //   ),
              // ),
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  height: 32.0,
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
                                var splits = textEditingController!.text.split(' ');
                                splits.last = emote!;
                                textEditingController!.text = splits.join(' ') + ' ';
                                textEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController!.text.length));
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
                    child: Icon(Icons.emoji_emotions_outlined),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  height: 32.0,
                  child: InkWell(
                    onTap: () async {
                      widget.channel?.send(textEditingController!.text);
                      textEditingController?.clear();
                      setState(() {});
                    },
                    child: Icon(Icons.send),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  List<Widget> getAutoCompletionUsers() => [
        if (textEditingController!.text.split(' ').last.length >= 2 && !textEditingController!.text.endsWith(' '))
          for (var user in widget.channel!.users.values.expand((element) => element))
            if ('${AutocompletePresenter.cache.userPrefix! ? '@' : ''}$user'.toLowerCase().contains(textEditingController!.text.split(' ').last.toLowerCase()) && (AutocompletePresenter.cache.userPrefix! ? textEditingController!.text.startsWith('@') : true))
              InkWell(
                onTap: () async {
                  var splits = textEditingController!.text.split(' ');
                  splits.last = user;
                  textEditingController!.text = splits.join(' ') + ' ';
                  textEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController!.text.length));
                  focusNode.requestFocus();
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(user),
                ),
              ),
      ];
}
