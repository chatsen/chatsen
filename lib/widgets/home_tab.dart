import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatsen/api/twitch/twitch.dart';
import 'package:chatsen/components/boxlistener.dart';
import 'package:chatsen/components/tile.dart';
import 'package:chatsen/data/twitch/search_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/components/modal.dart';
import '/components/separator.dart';
import '/components/surface.dart';
import '/data/twitch/stream_data.dart';
import '/data/twitch_account.dart';
import '/modal/chatsen.dart';
import '/tmi/channel/channel_event.dart';
import '/tmi/client/client.dart';
import '/widgets/avatar_button.dart';

class HomeSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}

class SliverSearchBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => const SafeArea(child: Placeholder());

  @override
  double get maxExtent => 256.0;

  @override
  double get minExtent => 256.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TwitchAccount? account;
  TextEditingController searchTextController = TextEditingController();
  Future<List<StreamData>>? recommendedStreams;
  Future<List<StreamData>>? topStreams;
  Future<List<SearchData>>? searchResults;

  Future<void> refresh() async {
    recommendedStreams = Twitch.streams(
      account!.tokenData,
      userLogins: [
        'forsen',
        'btmc',
        'nymn',
        'vaxei_osu',
        'mrekkosu',
        'shigetora',
        'enviosity',
        // 'theactingmale',
        'kitboga',
        'cdawgva',
        'gigguk',
      ],
    );
    topStreams = Twitch.streams(account!.tokenData);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final twitchAccountsBox = Hive.box('TwitchAccounts');
    final accountSettingsBox = Hive.box('AccountSettings');
    account = twitchAccountsBox.values.firstWhereOrNull((element) => (element as TwitchAccount).tokenData.hash == accountSettingsBox.get('activeTwitchAccount')) as TwitchAccount?;

    accountSettingsBox.listenable().addListener(() {
      account = twitchAccountsBox.values.firstWhereOrNull((element) => (element as TwitchAccount).tokenData.hash == accountSettingsBox.get('activeTwitchAccount')) as TwitchAccount?;
      setState(() {
        refresh();
      });
    });

    if (account != null) {
      refresh();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('AccountSettings'),
        keys: const ['activeTwitchAccount'],
        builder: (BuildContext context, Box<dynamic> box) {
          if (account == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.chatsen,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.startUsingTheApp,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  IconButton(
                    onPressed: () {
                      Modal.show(
                        context: context,
                        child: const ChatsenModal(),
                      );
                    },
                    iconSize: 64.0,
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                refresh();
              });
              return Future.wait([recommendedStreams!, topStreams!]);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Platform.isWindows ? Colors.transparent : null,
                  // foregroundColor: Colors.transparent,
                  shadowColor: Platform.isWindows ? Colors.transparent : null,
                  title: const Text('Chatsen'),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: AvatarButton(),
                    ),
                  ],
                ),
                SliverList.list(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Surface(
                        type: SurfaceType.surfaceVariant,
                        borderRadius: BorderRadius.circular(48.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 16.0),
                            const Icon(Icons.search),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: false,
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!.searchForChannels,
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                controller: searchTextController,
                                onChanged: (text) {
                                  if (text.isEmpty) {
                                    setState(() {
                                      searchResults = null;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    searchResults = Twitch.channelSearch(account!.tokenData, text);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
                if (searchResults != null)
                  FutureBuilder<List<SearchData>>(
                    future: searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return SliverList.list(children: const [Text('Error')]);
                      if (!snapshot.hasData) {
                        return SliverList.list(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      }
                      return SliverList.list(
                        children: [
                          Tile(
                            onTap: () {
                              final client = context.read<Client>();
                              final channelName = '#${searchTextController.text}';
                              if (!client.channels.state.any((channel) => channel.name == channelName)) {
                                client.channels.join(channelName);
                                client.receiver.send('JOIN $channelName');
                                client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
                              }
                              WidgetsBinding.instance.scheduleFrameCallback((_) {
                                WidgetsBinding.instance.scheduleFrameCallback((_) {
                                  DefaultTabController.of(context).animateTo(client.channels.state.indexWhere((channel) => channel.name == channelName) + 1);
                                });
                              });
                            },
                            prefix: ClipRRect(
                              borderRadius: BorderRadius.circular(48.0),
                              clipBehavior: Clip.antiAlias,
                              child: Material(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                                child: const Icon(Icons.add_circle_outline),
                              ),
                            ),
                            title: searchTextController.text,
                          ),
                          const Separator(),
                          for (final searchResult in snapshot.data!)
                            Tile(
                              onTap: () {
                                final client = context.read<Client>();
                                final channelName = '#${searchResult.broadcasterLogin}';
                                if (!client.channels.state.any((channel) => channel.name == channelName)) {
                                  client.channels.join(channelName);
                                  client.receiver.send('JOIN $channelName');
                                  client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
                                }
                                WidgetsBinding.instance.scheduleFrameCallback((_) {
                                  WidgetsBinding.instance.scheduleFrameCallback((_) {
                                    DefaultTabController.of(context).animateTo(client.channels.state.indexWhere((channel) => channel.name == channelName) + 1);
                                  });
                                });
                              },
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(48.0),
                                clipBehavior: Clip.antiAlias,
                                child: Material(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                                  // child: const Icon(Icons.add_circle_outline),
                                  child: Ink.image(image: NetworkImage(searchResult.thumbnailUrl)),
                                ),
                              ),
                              title: searchResult.displayName,
                            ),
                        ],
                      );
                    },
                  ),
                if (searchResults == null)
                  FutureBuilder<List<StreamData>>(
                    future: recommendedStreams,
                    builder: (context, snapshot) {
                      if (snapshot.hasError || (snapshot.data?.isEmpty ?? false)) return SliverList.list(children: const []);
                      if (!snapshot.hasData) {
                        return SliverList.list(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      }
                      return SliverList.list(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.222),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                              ),
                              items: [
                                for (final stream in snapshot.data!)
                                  StreamPreviewLarge(
                                    stream: stream,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
                if (searchResults == null)
                  FutureBuilder<List<StreamData>>(
                    future: topStreams,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SliverList.list(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      }
                      return SliverList.list(
                        children: [
                          for (final stream in snapshot.data!)
                            //Padding(
                            //  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            //  child: StreamPreviewPill(stream: stream),
                            //),
                            StreamPreviewSmall(stream: stream),
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      );
}

class StreamPreviewPill extends StatelessWidget {
  const StreamPreviewPill({
    super.key,
    required this.stream,
  });

  final StreamData stream;

  @override
  Widget build(BuildContext context) => Surface(
        type: SurfaceType.surfaceVariant,
        borderRadius: BorderRadius.circular(12.0),
        shouldClip: true,
        onTap: () {},
        child: Stack(
          children: [
            Positioned.fill(
              child: Ink.image(
                image: NetworkImage(stream.thumbnailUrl.replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.66),
                      Colors.black.withOpacity(0.66),
                    ],
                    stops: const [
                      0.0,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stream.userName, style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    stream.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class StreamPreviewSmall extends StatelessWidget {
  const StreamPreviewSmall({
    super.key,
    required this.stream,
  });

  final StreamData stream;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final client = context.read<Client>();
        final channelName = '#${stream.userLogin}';
        if (!client.channels.state.any((channel) => channel.name == channelName)) {
          client.channels.join(channelName);
          client.receiver.send('JOIN $channelName');
          client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
        }
        WidgetsBinding.instance.scheduleFrameCallback((_) {
          WidgetsBinding.instance.scheduleFrameCallback((_) {
            DefaultTabController.of(context).animateTo(client.channels.state.indexWhere((channel) => channel.name == channelName) + 1);
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(
              height: 64.0 + 16.0, // 96.0,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    (stream.thumbnailUrl.replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    stream.userName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stream.title.trim(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stream.gameName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      // Red dot 8x8
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${stream.viewerCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 16.0),
                      const Icon(
                        Icons.alarm,
                        size: 12.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          '${DateTime.now().difference(stream.startedAt)}'.split('.').first,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamPreviewLarge extends StatelessWidget {
  const StreamPreviewLarge({
    super.key,
    required this.stream,
  });

  final StreamData stream;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          final client = context.read<Client>();
          final channelName = '#${stream.userLogin}';
          if (!client.channels.state.any((channel) => channel.name == channelName)) {
            client.channels.join(channelName);
            client.receiver.send('JOIN $channelName');
            client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
          }
          WidgetsBinding.instance.scheduleFrameCallback((_) {
            WidgetsBinding.instance.scheduleFrameCallback((_) {
              DefaultTabController.of(context).animateTo(client.channels.state.indexWhere((channel) => channel.name == channelName) + 1);
            });
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Ink.image(
                image: NetworkImage(stream.thumbnailUrl.replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(1.0),
                  ],
                  stops: const [
                    0.25,
                    1.0,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    stream.userName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stream.title.trim(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stream.gameName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      // Red dot 8x8
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${stream.viewerCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 16.0),
                      Icon(
                        Icons.alarm,
                        size: 12.0,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          '${DateTime.now().difference(stream.startedAt)}'.split('.').first,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
