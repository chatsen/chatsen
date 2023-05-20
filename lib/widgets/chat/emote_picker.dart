import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:http/http.dart' as http;

import '../../components/surface.dart';
import '../../data/emote.dart';
import '../../tmi/channel/channel.dart';

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  SectionHeaderDelegate(this.title, [this.height = 24]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text(title),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

enum PickerMode {
  gif,
  emote,
}

class EmotePicker extends StatefulWidget {
  final Channel channel;

  const EmotePicker({
    super.key,
    required this.channel,
  });

  @override
  State<EmotePicker> createState() => _EmotePickerState();
}

class _EmotePickerState extends State<EmotePicker> {
  PickerMode mode = PickerMode.emote;
  Future<http.Response>? gifSearch;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    gifSearch = http.get(Uri.parse('https://g.tenor.com/v1/search?q=forsen&key=LIVDSRZULELA&limit=50'));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelEmotes = widget.channel.channelEmotes.state;
    final globalEmotes = widget.channel.client.globalEmotes.state + widget.channel.client.twitchUserEmotes.state;
    final allEmotes = channelEmotes + globalEmotes;

    final groups = <String, List<Emote>>{};
    for (final providerGroup in groupBy(allEmotes, (emote) => emote.provider).entries) {
      for (final category in groupBy(providerGroup.value, (emote) => emote.category).entries) {
        groups.putIfAbsent(category.key ?? providerGroup.key.name, () => []);
        groups[category.key ?? providerGroup.key.name]!.addAll(category.value);
      }
    }

    return Column(
      children: [
        const SizedBox(height: 4.0),
        Surface(
          type: SurfaceType.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     children: [
              //       Surface(
              //         borderRadius: BorderRadius.circular(8.0),
              //         type: SurfaceType.background,
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              //           child: Text('GIFs'),
              //         ),
              //         onTap: () {},
              //       ),
              //       const SizedBox(width: 4.0),
              //       Surface(
              //         borderRadius: BorderRadius.circular(8.0),
              //         type: SurfaceType.background,
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              //           child: Text('Emotes'),
              //         ),
              //         onTap: () {},
              //       ),
              //     ],
              //   ),
              // ),
              SegmentedButton<PickerMode>(
                segments: const [
                  ButtonSegment<PickerMode>(
                    value: PickerMode.gif,
                    label: Text('GIFs'),
                    icon: Icon(Icons.image_search_outlined),
                  ),
                  ButtonSegment<PickerMode>(
                    value: PickerMode.emote,
                    label: Text('Emote'),
                    icon: Icon(Icons.emoji_emotions_outlined),
                  ),
                ],
                selected: <PickerMode>{mode},
                onSelectionChanged: (selection) {
                  setState(() {
                    mode = selection.first;
                  });
                },
              ),
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Surface(
                  borderRadius: BorderRadius.circular(8.0),
                  // color: Colors.blue,
                  type: SurfaceType.background,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Search',
                            ),
                            onChanged: (value) {
                              if (mode == PickerMode.gif) {
                                gifSearch = http.get(Uri.parse('https://g.tenor.com/v1/search?q=$value&key=LIVDSRZULELA&limit=50'));
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      const Icon(Icons.search_outlined),
                      const SizedBox(width: 6.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        if (mode == PickerMode.gif)
          Expanded(
            child: FutureBuilder<http.Response>(
              future: gifSearch,
              builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final gifs = <GifInfo>[];
                final responseJson = json.decode(utf8.decode(snapshot.data!.bodyBytes)) as Map<String, dynamic>;
                for (final gif in responseJson['results']) {
                  gifs.add(GifInfo(
                    url: gif['media'][0]['tinygif']['url'] as String,
                    width: (gif['media'][0]['tinygif']['dims'][0] as int).toDouble(),
                    height: (gif['media'][0]['tinygif']['dims'][1] as int).toDouble(),
                    preview: gif['media'][0]['tinygif']['url'] as String,
                  ));
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildGifColumn(gifs.take((gifs.length / 2).toInt()).toList()),
                        const SizedBox(width: 8.0),
                        buildGifColumn(gifs.sublist((gifs.length / 2).toInt()).toList()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        if (mode == PickerMode.emote)
          Expanded(
            child: Row(
              children: [
                Container(
                  // color: Colors.red,
                  width: 48.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final category in groups.keys)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Surface(
                            borderRadius: BorderRadius.circular(64.0),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(category),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    // padding: EdgeInsets.zero,
                    slivers: [
                      for (final category in groups.entries)
                        MultiSliver(
                          pushPinnedChildren: true,
                          children: [
                            // SliverPersistentHeader(
                            //   delegate: SectionHeaderDelegate(providerGroup.key.name),
                            //   pinned: true,
                            // ),
                            // SliverPinnedHeader(
                            //   child: ColoredBox(
                            //     color: Colors.red,
                            //     child: ListTile(
                            //       //  textColor: titleColor,
                            //       title: Text(providerGroup.key.name),
                            //     ),
                            //   ),
                            // ),
                            SliverPinnedHeader(
                              child: ColoredBox(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(category.key),
                                ),
                              ),
                            ),

                            SliverGrid.extent(
                              maxCrossAxisExtent: 32.0 + 24.0,
                              children: [
                                for (final emote in category.value)
                                  Tooltip(
                                    message: emote.name,
                                    child: InkWell(
                                      onTap: () {
                                        // textEditingController.text = (textEditingController.text.split(' ') + [emote.code ?? emote.name]).where((element) => element.isNotEmpty).join(' ') + ' ';
                                        // textEditingController.selection = TextSelection.fromPosition(
                                        //   TextPosition(
                                        //     offset: textEditingController.text.length,
                                        //   ),
                                        // );
                                        // setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: emote.mipmap.last,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Expanded buildGifColumn(List<GifInfo> gifs) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final gif in gifs) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                gif.url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ],
      ),
    );
  }
}

class GifInfo {
  final String url;
  final String preview;
  final double width;
  final double height;

  GifInfo({
    required this.url,
    required this.preview,
    required this.width,
    required this.height,
  });
}

/*

SliverList.list(
          children: [
            for (final providerGroup in groupBy(allEmotes, (emote) => emote.provider).entries) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  providerGroup.key.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              GridView.extent(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: MediaQuery.of(context).padding.copyWith(top: 0.0, bottom: 0.0),
                maxCrossAxisExtent: 32.0 + 24.0,
                children: [
                  // Group emotes by provider
                  for (final emote in providerGroup.value)
                    Tooltip(
                      message: emote.name,
                      child: InkWell(
                        onTap: () {
                          // textEditingController.text = (textEditingController.text.split(' ') + [emote.code ?? emote.name]).where((element) => element.isNotEmpty).join(' ') + ' ';
                          // textEditingController.selection = TextSelection.fromPosition(
                          //   TextPosition(
                          //     offset: textEditingController.text.length,
                          //   ),
                          // );
                          // setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CachedNetworkImage(
                            emoteUrl: emote.mipmap.last,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),

*/
