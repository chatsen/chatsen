import 'package:cached_network_image/cached_network_image.dart';
import '/Components/WidgetTooltip.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../Consts.dart';
import '/Components/UI/WidgetBlur.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

import 'UI/NetworkImageWrapper.dart';

/// [EmoteListModal] is our modal view/widget designed to add and join new channels to the client.
class EmoteListModal extends StatefulWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;
  final Function(String? emote) insertEmote;

  const EmoteListModal({
    Key? key,
    required this.client,
    required this.channel,
    required this.insertEmote,
  }) : super(key: key);

  @override
  _EmoteListModalState createState() => _EmoteListModalState();
}

class _EmoteListModalState extends State<EmoteListModal> {
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

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: kUnverifiedVersion ? 1 : 4,
        child: Builder(builder: (context) {
          return WidgetBlur(
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
                    height: MediaQuery.of(context).size.height / 3.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32.0,
                          child: TabBar(
                            indicatorPadding: EdgeInsets.zero,
                            tabs: [
                              if (!kUnverifiedVersion) Tab(text: 'Channel'),
                              if (!kUnverifiedVersion) Tab(text: 'Twitch'),
                              if (!kUnverifiedVersion) Tab(text: 'Global'),
                              Tab(text: 'Emojis'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              if (!kUnverifiedVersion)
                                ListView(
                                  children: [
                                    for (var group in groupBy(widget.channel!.emotes, (dynamic emote) => emote.provider).entries) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                                        child: Text('${group.key}', style: Theme.of(context).textTheme.headline6),
                                      ),
                                      GridView.extent(
                                        maxCrossAxisExtent: 48.0,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          for (var emote in group.value.where((x) => x.name!.toLowerCase().contains(textEditingController!.text.toLowerCase()))) buildEmoteButton(emote),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              if (!kUnverifiedVersion)
                                GridView.extent(
                                  maxCrossAxisExtent: 48.0,
                                  children: [
                                    for (var emote in widget.channel!.transmitter!.emotes.where((x) => x.name!.toLowerCase().contains(textEditingController!.text.toLowerCase()))) buildEmoteButton(emote),
                                  ],
                                ),
                              if (!kUnverifiedVersion)
                                ListView(
                                  children: [
                                    for (var group in groupBy(widget.client!.emotes, (dynamic emote) => emote.provider).entries) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                                        child: Text('${group.key}', style: Theme.of(context).textTheme.headline6),
                                      ),
                                      GridView.extent(
                                        maxCrossAxisExtent: 48.0,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          for (var emote in group.value.where((x) => x.name!.toLowerCase().contains(textEditingController!.text.toLowerCase()))) buildEmoteButton(emote),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              GridView.extent(
                                maxCrossAxisExtent: 48.0,
                                children: [
                                  for (var emote in widget.client!.emojis.where((x) => x.name!.toLowerCase().contains(textEditingController!.text.toLowerCase()))) buildEmoteButton(emote),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48.0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => setState(() {}),
                          enableFeedback: false,
                        ),
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                              filled: false,
                              isDense: true,
                              hintText: 'Search emotes',
                              border: InputBorder.none,
                            ),
                            onChanged: (text) async => setState(() {}),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            await widget.client?.updateEmotes();
                            await widget.client?.updateBadges();
                            await widget.channel?.updateEmotes();
                            await widget.channel?.updateBadges();
                            await widget.channel?.transmitter?.updateUserEmotes();
                            setState(() {});
                          },
                          tooltip: 'Refresh emotes',
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1.0, color: Theme.of(context).dividerColor),
                ],
              ),
            ),
          );
        }),
      );

  WidgetTooltip buildEmoteButton(twitch.Emote emote) {
    return WidgetTooltip(
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
        onTap: () => widget.insertEmote((emote.alt ?? emote.name)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NetworkImageW(emote.mipmap!.last!),
        ),
      ),
    );
  }
}
