import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

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

class EmotePicker extends StatelessWidget {
  final Channel channel;

  const EmotePicker({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    final channelEmotes = channel.channelEmotes.state;
    final globalEmotes = channel.client.globalEmotes.state + channel.client.twitchUserEmotes.state;
    final allEmotes = channelEmotes + globalEmotes;

    return CustomScrollView(
      // padding: EdgeInsets.zero,
      slivers: [
        for (final providerGroup in groupBy(allEmotes, (emote) => emote.provider).entries)
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
                    child: Text(providerGroup.key.name),
                  ),
                ),
              ),

              SliverGrid.extent(
                maxCrossAxisExtent: 32.0 + 24.0,
                children: [
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
    );
  }
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
