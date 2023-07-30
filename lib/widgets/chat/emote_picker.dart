import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final String Function() getFieldInput;
  final void Function(String) setFieldInput;
  final void Function(String) insertFieldInput;

  const EmotePicker({
    super.key,
    required this.channel,
    required this.getFieldInput,
    required this.setFieldInput,
    required this.insertFieldInput,
  });

  @override
  State<EmotePicker> createState() => _EmotePickerState();
}

class _EmotePickerState extends State<EmotePicker> {
  PickerMode mode = PickerMode.emote;
  Future<http.Response>? gifSearch;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    gifSearch = http.get(Uri.parse('https://g.tenor.com/v1/search?q=forsen&key=LIVDSRZULELA&limit=50'));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelEmotes = widget.channel.channelEmotes.state;
    final globalEmotes = widget.channel.client.globalEmotes.state + widget.channel.client.twitchUserEmotes.state;
    final allEmotes = channelEmotes + globalEmotes;

    final groups = <String, List<Emote>>{};
    final groupKeys = <String, GlobalKey>{};
    for (final providerGroup in groupBy(allEmotes, (emote) => emote.provider).entries) {
      for (final category in groupBy(providerGroup.value, (emote) => emote.category).entries) {
        groups.putIfAbsent(category.key ?? providerGroup.key.name, () => []);
        groups[category.key ?? providerGroup.key.name]!.addAll(category.value);
        groupKeys.putIfAbsent(category.key ?? providerGroup.key.name, () => GlobalKey());
      }
    }

    const icons = {
      "Symbols": Icon(Icons.star_border_outlined),
      "Activities": Icon(Icons.local_activity_outlined),
      "Flags": Icon(Icons.flag_outlined),
      "Travel & Places": Icon(Icons.card_travel_outlined),
      "Food & Drink": Icon(Icons.fastfood_outlined),
      "Animals & Nature": Icon(Icons.pest_control_outlined),
      "People & Body": Icon(Icons.people_outline_outlined),
      "Objects": Icon(Icons.emoji_objects_outlined),
      "Component": Icon(Icons.settings_input_component_outlined),
      "Smileys & Emotion": Icon(Icons.emoji_emotions_outlined),
    };

    return Surface(
      type: SurfaceType.background,
      child: Column(
        children: [
          if (mode == PickerMode.gif)
            Expanded(
              child: FutureBuilder<http.Response>(
                future: gifSearch,
                builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
                          buildGifColumn(gifs.take(gifs.length ~/ 2).toList()),
                          const SizedBox(width: 8.0),
                          buildGifColumn(gifs.sublist(gifs.length ~/ 2).toList()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (mode == PickerMode.emote)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: scrollController,
                      // padding: EdgeInsets.zero,
                      slivers: [
                        SliverList.list(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                              child: Surface(
                                borderRadius: BorderRadius.circular(128.0),
                                // color: Colors.white,
                                type: SurfaceType.surfaceVariant,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!.search,
                                      isDense: true,
                                    ),
                                    onChanged: (text) => setState(() {}),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final category in groups.entries.where((group) => group.value.any((emote) => emote.name.toLowerCase().contains(searchController.text.toLowerCase()))))
                          MultiSliver(
                            pushPinnedChildren: true,
                            children: [
                              SliverPinnedHeader(
                                key: groupKeys[category.key],
                                child: ColoredBox(
                                  color: Theme.of(context).colorScheme.background,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 4.0, right: 4.0),
                                    child: Text(category.key),
                                  ),
                                ),
                              ),
                              SliverGrid.extent(
                                maxCrossAxisExtent: 32.0 + 16.0,
                                children: [
                                  for (final emote in category.value.where((emote) => emote.name.toLowerCase().contains(searchController.text.toLowerCase())))
                                    Tooltip(
                                      message: emote.name,
                                      child: InkWell(
                                        onTap: () async => widget.insertFieldInput(emote.code ?? emote.name),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                  Surface(
                    type: SurfaceType.surfaceVariant,
                    child: SizedBox(
                      height: 48.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        children: [
                          for (final category in groups.keys)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Surface(
                                type: SurfaceType.surface,
                                onTap: () async {
                                  final context = groupKeys[category]!.currentContext!;
                                  Scrollable.maybeOf(context)!.position.jumpTo(Scrollable.maybeOf(context)!.position.maxScrollExtent);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Scrollable.maybeOf(context)!.position.ensureVisible(
                                          context.findRenderObject()!,
                                          duration: const Duration(milliseconds: 500),
                                        );
                                  });
                                },
                                borderRadius: BorderRadius.circular(64.0),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: icons.containsKey(category)
                                          ? icons[category]
                                          : Text(
                                              category,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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

          // const SizedBox(height: 4.0),
          // Surface(
          //   type: SurfaceType.transparent,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // Padding(
          //       //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       //   child: Row(
          //       //     children: [
          //       //       Surface(
          //       //         borderRadius: BorderRadius.circular(8.0),
          //       //         type: SurfaceType.background,
          //       //         child: const Padding(
          //       //           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          //       //           child: Text('GIFs'),
          //       //         ),
          //       //         onTap: () {},
          //       //       ),
          //       //       const SizedBox(width: 4.0),
          //       //       Surface(
          //       //         borderRadius: BorderRadius.circular(8.0),
          //       //         type: SurfaceType.background,
          //       //         child: const Padding(
          //       //           padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          //       //           child: Text('Emotes'),
          //       //         ),
          //       //         onTap: () {},
          //       //       ),
          //       //     ],
          //       //   ),
          //       // ),
          //       SegmentedButton<PickerMode>(
          //         segments: const [
          //           ButtonSegment<PickerMode>(
          //             value: PickerMode.gif,
          //             label: Text('GIFs'),
          //             icon: Icon(Icons.image_search_outlined),
          //           ),
          //           ButtonSegment<PickerMode>(
          //             value: PickerMode.emote,
          //             label: Text('Emote'),
          //             icon: Icon(Icons.emoji_emotions_outlined),
          //           ),
          //         ],
          //         selected: <PickerMode>{mode},
          //         onSelectionChanged: (selection) {
          //           setState(() {
          //             mode = selection.first;
          //           });
          //         },
          //       ),
          //       const SizedBox(height: 4.0),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //         child: Surface(
          //           borderRadius: BorderRadius.circular(8.0),
          //           // color: Colors.blue,
          //           type: SurfaceType.background,
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left: 8.0),
          //                   child: TextField(
          //                     controller: searchController,
          //                     decoration: const InputDecoration(
          //                       isDense: true,
          //                       border: InputBorder.none,
          //                       hintText: 'Search',
          //                     ),
          //                     onChanged: (value) {
          //                       if (mode == PickerMode.gif) {
          //                         gifSearch = http.get(Uri.parse('https://g.tenor.com/v1/search?q=$value&key=LIVDSRZULELA&limit=50'));
          //                         setState(() {});
          //                       }
          //                     },
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(width: 2.0),
          //               const Icon(Icons.search_outlined),
          //               const SizedBox(width: 6.0),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 4.0),

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
