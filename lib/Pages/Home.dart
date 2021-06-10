import 'dart:async';
import 'dart:io';

import 'package:chatsen/Components/HomeEndDrawer.dart';
import 'package:chatsen/Components/UpdateModal.dart';
import 'package:chatsen/Mentions/MentionsCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

/// Our [HomePage]. This will contain access to everything: from Settings via a drawer, access to the different chat channels to everything else related to our application.
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    // @required this.client,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements twitch.Listener {
  twitch.Client client = twitch.Client();
  Future<bool>? updateFuture;

  Future<void> loadChannelHistory() async {
    var channels = await Hive.openBox('Channels');
    await client.joinChannels(List<String>.from(channels.values));
    setState(() {});
  }

  @override
  void initState() {
    AccountPresenter.findCurrentAccount().then(
      (account) async {
        print(account!.login);
        client.swapCredentials(
          twitch.Credentials(
            clientId: account.clientId,
            id: account.id,
            login: account.login!,
            token: account.token,
          ),
        );
      },
    );

    loadChannelHistory();

    client.listeners.add(this);

    updateFuture = UpdateModal.hasUpdate();

    Timer.periodic(Duration(minutes: 5), (timer) {
      print('Checking for updates...');
      setState(() {
        updateFuture = UpdateModal.hasUpdate();
      });
    });

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      UpdateModal.searchForUpdate(context);
    });

    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    client.listeners.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: client.channels.length,
        child: BlocBuilder<StreamOverlayBloc, StreamOverlayState>(
          builder: (context, state) {
            var horizontal = MediaQuery.of(context).size.aspectRatio > 1.0;
            // // var videoPlayer = Container(color: Theme.of(context).primaryColor);
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
                  var currentChannel = client.channels.isNotEmpty ? client.channels[DefaultTabController.of(context)!.index] : null;
                  return HomeDrawer(
                    client: client,
                    channel: currentChannel,
                  );
                },
              ),
              endDrawer: HomeEndDrawer(),
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
                          InkWell(
                            onTap: () async => Scaffold.of(context).openEndDrawer(),
                            child: Container(
                              height: 32.0,
                              width: 32.0,
                              child: Icon(Icons.alternate_email, size: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: [
                      for (var channel in client.channels)
                        ChatView(
                          client: client,
                          channel: channel,
                        ),
                    ],
                  ),
                  FutureBuilder<bool>(
                    future: updateFuture,
                    builder: (context, future) => future.hasData && future.data == true
                        ? Align(
                            alignment: Alignment.topRight,
                            child: SafeArea(
                              child: IconButton(
                                icon: Icon(
                                  Icons.system_update,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async => UpdateModal.searchForUpdate(context),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            );

            return state is StreamOverlayClosed
                ? scaffold
                : (horizontal
                    ? Row(
                        children: [
                          Expanded(
                            child: SafeArea(child: videoPlayer!),
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
  void onMessage(twitch.Channel? channel, twitch.Message message) {
    if (message.mention) BlocProvider.of<MentionsCubit>(context).add(message);
    if (NotificationPresenter.cache.mentionNotification! && message.mention) {
      NotificationWrapper.of(context)!.sendNotification(
        payload: message.body,
        title: message.user!.login,
        subtitle: message.body,
      );
    }
  }

  @override
  void onHistoryLoaded(twitch.Channel channel) {}

  @override
  void onWhisper(twitch.Channel channel, twitch.Message message) {
    if (NotificationPresenter.cache.whisperNotification! && message.user!.id != channel.receiver!.credentials!.id) {
      NotificationWrapper.of(context)!.sendNotification(
        payload: message.body,
        title: message.user!.login,
        subtitle: message.body,
      );
    }
  }
}
