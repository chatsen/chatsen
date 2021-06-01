import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:version/version.dart';
import '/Components/ChannelJoinModal.dart';
import '/Components/HomeDrawer.dart';
import '/Components/HomeTab.dart';
import '/Components/Notification.dart';
import '/MVP/Presenters/AccountPresenter.dart';
import '/MVP/Presenters/NotificationPresenter.dart';
import '/StreamOverlay/StreamOverlayBloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';
import '/Views/Chat.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

/// Our [HomePage]. This will contain access to everything: from Settings via a drawer, access to the different chat channels to everything else related to our application.
class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    // @required this.client,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements twitch.Listener {
  twitch.Client client;
  TextEditingController textEditingController;

  Future<void> loadChannelHistory() async {
    var channels = await Hive.openBox('Channels');
    await client.joinChannels(List<String>.from(channels.values));
    setState(() {});
  }

  @override
  void initState() {
    client = twitch.Client();

    AccountPresenter.findCurrentAccount().then(
      (account) async {
        print(account.login);
        await client.swapCredentials(
          twitch.Credentials(
            clientId: account.clientId,
            id: account.id,
            login: account.login,
            token: account.token,
          ),
        );
      },
    );

    loadChannelHistory();

    textEditingController = TextEditingController();
    client.listeners.add(this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var packageInfo = await PackageInfo.fromPlatform();
      var response = await http.get(Uri.parse('https://api.github.com/repos/chatsen/chatsen/tags'));
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      var releases = <Version, String>{};
      for (var tagData in jsonResponse) {
        try {
          releases[Version.parse(tagData['name'].split('+').first)] = tagData['name'];
          // ignore: empty_catches
        } catch (e) {}
      }

      var releasesSorted = releases.keys.toList()..sort((a1, a2) => a1.compareTo(a2));

      var lastRelease = releasesSorted.last;
      var currentRelease = Version.parse(packageInfo.version);

      if (currentRelease < lastRelease) {
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: WidgetBlur(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 1.0, color: Theme.of(context).dividerColor),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(width: 32.0, height: 2.0, color: Theme.of(context).dividerColor),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Text(
                              'An update is available',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Text(
                              '${releases[lastRelease]} (you: $currentRelease+${packageInfo.buildNumber})',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            OutlinedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                var savePath = (await getApplicationDocumentsDirectory()).path;

                                if (Platform.isAndroid) {
                                  var response = await http.get(Uri.parse('https://github.com/chatsen/chatsen/releases/download/${releases[lastRelease]}/Android.apk'));
                                  await File('$savePath/Update.apk').writeAsBytes(response.bodyBytes, flush: true);
                                  await OpenFile.open('$savePath/Update.apk');
                                } else if (Platform.isIOS) {
                                  var response = await http.get(Uri.parse('https://github.com/chatsen/chatsen/releases/download/${releases[lastRelease]}/iOS.ipa'));
                                  await File('$savePath/Update.ipa').writeAsBytes(response.bodyBytes, flush: true);
                                  await OpenFile.open('$savePath/Update.ipa');
                                }
                              },
                              child: Text('Download update'),
                            ),
                            SizedBox(width: 8.0),
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            SizedBox(width: 16.0),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 1.0, color: Theme.of(context).dividerColor),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    client.listeners.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: client.channels.length,
        child: BlocBuilder<StreamOverlayBloc, StreamOverlayState>(
          builder: (context, state) {
            var horizontal = MediaQuery.of(context).size.aspectRatio > 1.0;
            // var videoPlayer = Container(color: Theme.of(context).primaryColor);
            var videoPlayer = state is StreamOverlayOpened
                ? WebView(
                    initialUrl: 'https://player.twitch.tv/?channel=${state.channelName}&enableExtensions=true&muted=false&parent=pornhub.com',
                    javascriptMode: JavascriptMode.unrestricted,
                    allowsInlineMediaPlayback: true,
                  )
                : null;

            var scaffold = Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              drawer: Builder(
                builder: (context) {
                  var currentChannel = client.channels.isNotEmpty ? client.channels[DefaultTabController.of(context).index] : null;
                  return HomeDrawer(
                    client: client,
                    channel: currentChannel,
                  );
                },
              ),
              bottomNavigationBar: Builder(
                builder: (context) => SafeArea(
                  child: Container(
                    height: 32.0,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Builder(
                            builder: (context) => InkWell(
                              onTap: () async => Scaffold.of(context).openDrawer(),
                              child: Container(
                                height: 32.0,
                                width: 32.0,
                                child: Icon(Icons.menu),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: TabBar(
                                labelPadding: EdgeInsets.only(left: 8.0),
                                isScrollable: true,
                                tabs: client.channels
                                    .map(
                                      (channel) => HomeTab(
                                        client: client,
                                        channel: channel,
                                        refresh: () => setState(() {}),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          Tooltip(
                            message: 'Add/join a channel',
                            child: InkWell(
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: ChannelJoinModal(
                                        client: client,
                                        refresh: () => setState(() {}),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 32.0,
                                width: 32.0,
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Builder(
                builder: (context) => TabBarView(
                  children: [
                    for (var channel in client.channels)
                      ChatView(
                        client: client,
                        channel: channel,
                      ),
                  ],
                ),
              ),
            );

            return state is StreamOverlayClosed
                ? scaffold
                : (horizontal
                    ? Row(
                        children: [
                          Expanded(
                            child: SafeArea(child: videoPlayer),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: SizedBox(
                              width: 340.0,
                              child: scaffold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SafeArea(
                            child: AspectRatio(
                              aspectRatio: 16.0 / 9.0,
                              child: videoPlayer,
                            ),
                          ),
                          Expanded(
                            child: scaffold,
                          ),
                        ],
                      ));
          },
        ),
      );

  @override
  void onChannelStateChange(twitch.Channel channel, twitch.ChannelState state) {}

  @override
  void onConnectionStateChange(twitch.Connection connection, twitch.ConnectionState state) {}

  @override
  void onMessage(twitch.Channel channel, twitch.Message message) {
    if (NotificationPresenter.cache.mentionNotification && message.mention) {
      NotificationWrapper.of(context).sendNotification(
        payload: message.body,
        title: message.user.login,
        subtitle: message.body,
      );
    }
  }

  @override
  void onHistoryLoaded(twitch.Channel channel) {}

  @override
  void onWhisper(twitch.Channel channel, twitch.Message message) {
    if (NotificationPresenter.cache.whisperNotification && message.user.id != channel.receiver.credentials.id) {
      NotificationWrapper.of(context).sendNotification(
        payload: message.body,
        title: message.user.login,
        subtitle: message.body,
      );
    }
  }
}
