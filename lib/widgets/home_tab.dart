import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/twitch_account.dart';
import '../tmi/channel/channel_event.dart';
import '../tmi/client/client.dart';
import '/widgets/avatar_button.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<http.Response> recommendedStreams;
  late Future<http.Response> streams;
  Future<http.Response>? search;
  TwitchAccount? account;
  TextEditingController searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final twitchAccountsBox = Hive.box('TwitchAccounts');
    final accountSettingsBox = Hive.box('AccountSettings');
    account = twitchAccountsBox.values.firstWhere((element) => (element as TwitchAccount).tokenData.hash == accountSettingsBox.get('activeTwitchAccount')) as TwitchAccount;

    streams = http.get(
      Uri.parse('https://api.twitch.tv/helix/streams?first=100'),
      headers: {
        'Client-ID': '${account?.tokenData.clientId}',
        'Authorization': 'Bearer ${account?.tokenData.accessToken}',
      },
    );
    recommendedStreams = http.get(
      Uri.parse('https://api.twitch.tv/helix/streams?' +
          List<String>.from([
            'forsen',
            'btmc',
            'nymn',
            'shigetora',
            'enviosity',
          ].map(
            (e) => 'user_login=$e',
          )).join('&')),
      headers: {
        'Client-ID': '${account?.tokenData.clientId}',
        'Authorization': 'Bearer ${account?.tokenData.accessToken}',
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<http.Response>(
      future: recommendedStreams,
      builder: (context, snapshot) {
        return FutureBuilder<http.Response>(
          future: streams,
          builder: (context, snapshotAll) {
            if (snapshot.data == null || snapshotAll.data == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            var responseJson = json.decode(utf8.decode(snapshot.data!.bodyBytes));
            var responseJsonAll = json.decode(utf8.decode(snapshotAll.data!.bodyBytes));

            return ListView(
              children: [
                // const AspectRatio(
                //   aspectRatio: 16 / 9,
                //   child: WebView(
                //     initialUrl: 'https://player.twitch.tv/?channel=forsen&enableExtensions=true&muted=true&parent=chatsen.app&player=popout&volume=1.0',
                //     javascriptMode: JavascriptMode.unrestricted,
                //     allowsInlineMediaPlayback: true,
                //     userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                //   ),
                // ),
                // CookiesManager(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Material(
                    // color: Colors.red,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(48.0),
                    child: SizedBox(
                      height: 48.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 16.0),
                            const Icon(Icons.search),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: TextField(
                                controller: searchTextController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!.searchForChannels,
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    if (text.isEmpty) {
                                      search = null;
                                    } else {
                                      search?.ignore();
                                      search = null;
                                      search = http.get(
                                        Uri.parse('https://api.twitch.tv/helix/search/channels?query=$text'),
                                        headers: {
                                          'Client-ID': '${account?.tokenData.clientId}',
                                          'Authorization': 'Bearer ${account?.tokenData.accessToken}',
                                        },
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            const AvatarButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (search != null) ...[
                  FutureBuilder<http.Response>(
                    future: search,
                    builder: (context, snapshotSearch) {
                      if (snapshotSearch.data == null) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      final responseJsonSearch = json.decode(utf8.decode(snapshotSearch.data!.bodyBytes));

                      return Column(
                        // shrinkWrap: true,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var stream in responseJsonSearch['data'])
                            InkWell(
                              onTap: () {
                                final client = context.read<Client>();
                                final channelName = '#${stream['broadcaster_login']}';
                                client.channels.join(channelName);
                                client.receiver.send('JOIN $channelName');
                                client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 48.0,
                                      height: 48.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(48.0),
                                        clipBehavior: Clip.antiAlias,
                                        child: Material(
                                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                                          child: Image.network(
                                            '${stream['thumbnail_url']}',
                                            height: 48.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        '${stream['display_name']}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
                if (search == null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.recommendedChannels,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  for (var stream in responseJson['data']) StreamPreviewSmall(stream: stream),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.popularChannels,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  for (var stream in responseJsonAll['data']) StreamPreviewSmall(stream: stream),
                ],
              ],
            );
          },
        );
      });
}

class StreamPreviewSmall extends StatelessWidget {
  const StreamPreviewSmall({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final dynamic stream;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final client = context.read<Client>();
        final channelName = '#${stream['user_login']}';
        client.channels.join(channelName);
        client.receiver.send('JOIN $channelName');
        client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channelName)?.add(ChannelJoin(client.receiver, client.transmitter));
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
                    ((stream['thumbnail_url'] as String).replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
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
                    stream['user_name'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stream['title'].trim(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${stream['game_name']}',
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
                        '${stream['viewer_count']}',
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
                          '${DateTime.now().difference(DateTime.parse(stream['started_at']))}'.split('.').first,
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
    Key? key,
    required this.stream,
  }) : super(key: key);

  final dynamic stream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {},
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Ink.image(
                  image: NetworkImage((stream['thumbnail_url'] as String).replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(1.0),
                      ],
                      stops: const [
                        0.5,
                        1.0,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stream['user_name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        stream['title'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Playing ${stream['game_name']} for ${stream['viewer_count']} viewers',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
