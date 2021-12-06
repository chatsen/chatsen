import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatsen/Mentions/CustomMentionsCubit.dart';
import 'package:chatsen/Pages/OAuth.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';

import '/Accounts/AccountsCubit.dart';
import '/Components/HomeEndDrawer.dart';
import '/Components/Modal/SetupModal.dart';
import '/Components/Modal/UpdateModal.dart';
import '/Components/UI/WidgetBlur.dart';
import '/Mentions/MentionsCubit.dart';
import '/Settings/Settings.dart';
import '/Settings/SettingsEvent.dart';
import '/Settings/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Components/ChannelJoinModal.dart';
import '/Components/HomeDrawer.dart';
import '/Components/HomeTab.dart';
import '/Components/Notification.dart';
import '/StreamOverlay/StreamOverlayBloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';
import '/Views/Chat.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'Account.dart';

/// Our [HomePage]. This will contain access to everything: from Settings via a drawer, access to the different chat channels to everything else related to our application.
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    // @required this.client,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class TitleBarHide extends StatefulWidget {
  final Widget child;

  const TitleBarHide({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<TitleBarHide> createState() => _TitleBarHideState();
}

class _TitleBarHideState extends State<TitleBarHide> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _HomePageState extends State<HomePage> implements twitch.Listener {
  twitch.Client client = twitch.Client();
  Future<bool>? updateFuture;
  bool immersive = true;
  // String ffz = '';

  Future<void> loadChannelHistory() async {
    var channels = await Hive.openBox('Channels');
    await client.joinChannels(List<String>.from(channels.values));
    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200)).then(
      // Should observe events instead, serves as a quick fix.
      (t) {
        try {
          var settings = BlocProvider.of<Settings>(context).state as SettingsLoaded;
          client.useRecentMessages = settings.historyUseRecentMessages;
        } catch (e) {}
        loadChannelHistory();
      },
    );

    Future.delayed(Duration(seconds: 1)).then(
      (t) => BlocProvider.of<AccountsCubit>(context).getActive().then(
        (account) async {
          if (account.token == null) return;

          var response = await http.get(
            Uri.parse('https://id.twitch.tv/oauth2/validate'),
            headers: {
              'Authorization': 'Bearer ${account.token}',
            },
          );
          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
          print(jsonResponse);

          if (jsonResponse['expires_in'] != null && Duration(seconds: (jsonResponse['expires_in'] ?? -1)) <= Duration(days: 7)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your login will expire soon! Please login again to refresh it.'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Re-login',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => OAuthPage(client: client)),
                  );
                },
              ),
            ));
          }

          if (jsonResponse['expires_in'] == null || (jsonResponse['expires_in'] ?? -1) < 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your login has expired! Please login again to refresh it.'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Re-login',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => OAuthPage(client: client)),
                  );
                },
              ),
            ));
            return;
          }

          return client.swapCredentials(
            twitch.Credentials(
              clientId: account.clientId,
              id: account.id,
              login: account.login!,
              token: account.token,
            ),
          );
        },
      ),
    );

    // AccountPresenter.findCurrentAccount().then(
    //   (account) async {
    //     print(account!.login);
    //     client.swapCredentials(
    //       twitch.Credentials(
    //         clientId: account.clientId,
    //         id: account.id,
    //         login: account.login!,
    //         token: account.token,
    //       ),
    //     );
    //   },
    // );

    client.listeners.add(this);

    updateFuture = UpdateModal.hasUpdate();

    Timer.periodic(Duration(minutes: 5), (timer) {
      // print('Checking for updates...');
      setState(() {
        updateFuture = UpdateModal.hasUpdate();
      });
    });

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      UpdateModal.searchForUpdate(context);
      var settingsState = BlocProvider.of<Settings>(context).state;
      if (settingsState is SettingsLoaded && settingsState.setupScreen) {
        await SetupModal.show(context, client);
        BlocProvider.of<Settings>(context).add(SettingsChange(state: settingsState.copyWith(setupScreen: false)));
      }
    });

    // http.get(Uri.parse('https://cdn.frankerfacez.com/static/player.b1d9260ef2ad14f4e3e4.js')).then((rep) => ffz = utf8.decode(rep.bodyBytes));

    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    client.listeners.remove(this);
    super.dispose();
  }

  var keyTest = GlobalKey();
  WebViewController? webViewController;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: client.channels.length,
        child: BlocBuilder<StreamOverlayBloc, StreamOverlayState>(
          builder: (context, state) {
            // ignore: invalid_use_of_protected_member
            if (!DefaultTabController.of(context)!.hasListeners) {
              DefaultTabController.of(context)!.addListener(() {
                setState(() {});
              });
            }
            var horizontal = MediaQuery.of(context).size.aspectRatio > 1.0;
            // // var videoPlayer = Container(color: Theme.of(context).primaryColor);
            var videoPlayer = state is StreamOverlayOpened
                ? Stack(
                    children: [
                      WebView(
                        key: keyTest,
                        initialUrl: 'https://player.twitch.tv/?channel=${state.channelName}&enableExtensions=true&muted=false&parent=chatsen.app',
                        javascriptMode: JavascriptMode.unrestricted,
                        allowsInlineMediaPlayback: true,
                        onWebViewCreated: (controller) => webViewController = controller,
                        onPageStarted: (url) {
                          // webViewController!.evaluateJavascript(ffz);

                          // var ffzResponse = await http.get(Uri.parse('https://cdn.frankerfacez.com/static/ffz_injector.user.js'));
                          // await webViewController!.evaluateJavascript(utf8.decode(ffzResponse.bodyBytes));
                        },
                        onPageFinished: (url) async {
                          // webViewController!.evaluateJavascript(ffz);
                          // var ffzResponse = await http.get(Uri.parse('https://cdn.frankerfacez.com/static/ffz_injector.user.js'));
                          // print(await webViewController!.evaluateJavascript(utf8.decode(ffzResponse.bodyBytes)));
                          // await webViewController!.evaluateJavascript('''
                          //   document.getElementsByClassName("video-player__overlay")[0].hidden = true;
                          //   document.getElementsByTagName("video")[0].controls = true;
                          // ''');
                        },
                        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                        // userAgent: 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0',
                      ),
                      // Positioned.fill(
                      //   child: Listener(
                      //     behavior: HitTestBehavior.translucent,
                      //     onPointerDown: (e) {
                      //       webViewController!.evaluateJavascript('''
                      //           document.getElementsByClassName("video-player__overlay")[0].hidden = true;
                      //           document.getElementsByTagName("video")[0].controls = true;
                      //         ''');
                      //     },
                      //   ),
                      // ),
                    ],
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
              backgroundColor: (state is StreamOverlayOpened && horizontal && immersive) ? Colors.transparent : null,
              bottomNavigationBar: Builder(
                builder: (context) {
                  var widget = Material(
                    color: client.channels.isEmpty ? Theme.of(context).colorScheme.surface.withAlpha(196) : Colors.transparent,
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (client.channels.isEmpty) Ink(height: 1.0, color: Theme.of(context).dividerColor),
                          SizedBox(
                            height: 40.0,
                            child: Row(
                              children: [
                                Builder(
                                  builder: (context) => InkWell(
                                    onTap: () async => Scaffold.of(context).openDrawer(),
                                    child: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      child: Icon(
                                        Icons.menu,
                                        color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                                      ),
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
                                    // child: ReorderableListView(
                                    //   // labelPadding: EdgeInsets.only(left: 8.0),
                                    //   // isScrollable: true,
                                    //   scrollDirection: Axis.horizontal,
                                    //   // children: client.channels
                                    //   //     .map(
                                    //   //       (channel) => HomeTab(
                                    //   //         key: ValueKey(channel),
                                    //   //         client: client,
                                    //   //         channel: channel,
                                    //   //         refresh: () => setState(() {}),
                                    //   //       ),
                                    //   //     )
                                    //   //     .toList(),
                                    //   children: [
                                    //     for (var channel in client.channels)
                                    //       InkWell(
                                    //         key: ValueKey(channel),
                                    //         onTap: () {
                                    //           DefaultTabController.of(context)!.animateTo(client.channels.indexOf(channel));
                                    //           // setState(() {});
                                    //         },
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text(
                                    //             '${channel.name!.replaceFirst('#', '')}',
                                    //             style: TextStyle(
                                    //               color: DefaultTabController.of(context)!.index == client.channels.indexOf(channel) ? Colors.red : null,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //   ],
                                    //   onReorder: (int oldIndex, int newIndex) {
                                    //     if (oldIndex < newIndex) {
                                    //       newIndex -= 1;
                                    //     }
                                    //     final item = client.channels.removeAt(oldIndex);
                                    //     client.channels.insert(newIndex, item);
                                    //     setState(() {});
                                    //   },
                                    //   // children: [],
                                    // ),
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
                                      height: 40.0,
                                      width: 40.0,
                                      child: Icon(
                                        (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.plus : Icons.add,
                                        color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async => Scaffold.of(context).openEndDrawer(),
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    child: Icon(
                                      (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.bell : Icons.alternate_email,
                                      size: 20.0,
                                      color: Theme.of(context).colorScheme.onSurface.withAlpha(64 * 3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  return client.channels.isEmpty ? WidgetBlur(child: widget) : widget;
                },
              ),
              body: Stack(
                children: [
                  if (client.channels.isEmpty)
                    SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Tutorial(client: client),
                          ),
                        ),
                      ),
                    ),
                  if (client.channels.isNotEmpty)
                    TabBarView(
                      children: [
                        for (var channel in client.channels)
                          ChatView(
                            client: client,
                            channel: channel,
                            shadow: (state is StreamOverlayOpened && horizontal && immersive),
                          ),
                      ],
                    ),
                  FutureBuilder<bool>(
                    future: updateFuture,
                    builder: (context, future) => future.hasData && future.data == true
                        ? Align(
                            alignment: Alignment.topRight,
                            child: SafeArea(
                              top: state is StreamOverlayClosed || horizontal,
                              child: IconButton(
                                icon: Icon(
                                  Icons.system_update,
                                  color: Theme.of(context).colorScheme.primary,
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
                // : Stack(
                //     children: [
                //       scaffold,
                //       if (horizontal) videoPlayer!,
                //       if (!horizontal)
                //         SafeArea(
                //           bottom: false,
                //           child: AspectRatio(
                //             aspectRatio: 16.0 / 9.0,
                //             child: videoPlayer!,
                //           ),
                //         ),
                //     ],
                //   );
                // : Padding(
                //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                //     child: TitleBarHide(
                //       child: Scaffold(
                //         drawerScrimColor: Colors.transparent,
                //         endDrawer: WidgetBlur(
                //           child: Ink(
                //             width: 320.0,
                //             color: Colors.transparent,
                //             // color: Theme.of(context).colorScheme.background.withAlpha(196),
                //             child: ChatView(
                //               channel: client.channels.first,
                //               client: client,
                //             ),
                //           ),
                //         ),
                //         body: Builder(
                //           builder: (context) => Stack(
                //             children: [
                //               videoPlayer!,
                //               IconButton(
                //                 icon: Icon(Icons.add),
                //                 onPressed: () => Scaffold.of(context).openEndDrawer(),
                //               ),
                //               ResizebleWidget(
                //                 child: ChatView(
                //                   channel: client.channels.first,
                //                   client: client,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                : (horizontal
                    ? (immersive
                        ? TitleBarHide(
                            child: Scaffold(
                              extendBody: true,
                              extendBodyBehindAppBar: true,
                              drawerScrimColor: Colors.transparent,
                              endDrawer: WidgetBlur(
                                child: Ink(
                                  width: 320.0,
                                  color: Colors.transparent,
                                  // color: Theme.of(context).colorScheme.background.withAlpha(196),
                                  child: scaffold,
                                ),
                              ),
                              body: Builder(
                                builder: (context) => Stack(
                                  children: [
                                    videoPlayer!,
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SafeArea(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.fullscreen_exit,
                                                color: Colors.white.withAlpha(192),
                                              ),
                                              onPressed: () => setState(() {
                                                immersive = false;
                                              }),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                (Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.line_horizontal_3 : Icons.menu,
                                                color: Colors.white.withAlpha(192),
                                              ),
                                              onPressed: () => Scaffold.of(context).openEndDrawer(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom, left: MediaQuery.of(context).padding.left),
                                    child: Stack(
                                      children: [
                                        videoPlayer!,
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SafeArea(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.fullscreen,
                                                    color: Colors.white.withAlpha(192),
                                                  ),
                                                  onPressed: () => setState(() {
                                                    immersive = true;
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: SizedBox(
                                  width: 340.0,
                                  child: MediaQuery.removePadding(
                                    removeLeft: true,
                                    context: context,
                                    child: scaffold,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    : Column(
                        children: [
                          SafeArea(
                            bottom: false,
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
  void onChannelStateChange(twitch.Channel channel, twitch.ChannelState state) {
    setState(() {});
  }

  @override
  void onConnectionStateChange(twitch.Connection connection, twitch.ConnectionState state) {
    setState(() {});
  }

  @override
  void onMessage(twitch.Channel? channel, twitch.Message message) {
    var splits = message.body!.split(' ').where((split) => split.isNotEmpty);
    // message.mention = true;
    var contains = BlocProvider.of<CustomMentionsCubit>(context).state.firstWhereOrNull((customMention) {
      if (customMention.enableRegex) return RegExp(customMention.pattern).hasMatch(message.body!);
      if (customMention.caseSensitive) {
        return splits.any(
          (split) => (split == customMention.pattern || split == '@${customMention.pattern}' || split == '${customMention.pattern},' || split == '@${customMention.pattern},'),
        );
      }
      return splits.any(
        (split) => (split.toLowerCase() == customMention.pattern.toLowerCase() || split.toLowerCase() == '@${customMention.pattern.toLowerCase()}' || split.toLowerCase() == '${customMention.pattern.toLowerCase()},' || split.toLowerCase() == '@${customMention.pattern.toLowerCase()},'),
      );
    });
    message.mention = message.mention || contains != null;
    if (message.mention) BlocProvider.of<MentionsCubit>(context).add(message);
    if ((BlocProvider.of<Settings>(context).state as SettingsLoaded).notificationOnMention && message.mention) {
      NotificationWrapper.of(context)!.sendNotification(
        payload: message.body,
        title: '${message.user!.login} in ${channel!.name}',
        subtitle: message.body,
      );
    }
  }

  @override
  void onHistoryLoaded(twitch.Channel channel) {}

  @override
  void onWhisper(twitch.Channel channel, twitch.Message message) {
    if ((BlocProvider.of<Settings>(context).state as SettingsLoaded).notificationOnWhisper && message.user!.id != channel.receiver!.credentials!.id) {
      NotificationWrapper.of(context)!.sendNotification(
        payload: message.body,
        title: message.user!.login,
        subtitle: message.body,
      );
    }
  }
}

class Tutorial extends StatelessWidget {
  final twitch.Client client;

  const Tutorial({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            Icon(Icons.not_started, size: 48.0, color: Theme.of(context).colorScheme.primary),
            Text('Getting started', style: Theme.of(context).textTheme.headline5),
            // Text('To get started, you can join a channel by pressing the + button below.', textAlign: TextAlign.center),
            // SizedBox(height: 32.0),
            // Text('Help', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 16.0),
                Expanded(child: Text('The add icon allows you to join channels by typing in their names. You can join multiple channels by separating the names with spaces: "chatsen btmc twitch"')),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.menu),
                SizedBox(width: 16.0),
                Expanded(child: Text('The menu icon will open the primary menu of the application. You can also hold-and-slide from the left edge to the right to open it!')),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.alternate_email),
                SizedBox(width: 16.0),
                Expanded(child: Text('The email icon will open the mentions menu of the application. You can also hold-and-slide from the right edge to the left to open it!')),
              ],
            ),
            SizedBox(height: 32.0),
            Text('Quick actions', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 16.0),
            Container(
              constraints: BoxConstraints(maxWidth: 128.0 * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AccountPage(
                        client: client,
                      ),
                    )),
                    icon: Icon(Icons.account_circle),
                    label: Text('Add an account'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0 / 2.0)),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await client.joinChannels(['#chatsen']);
                      var channelsBox = await Hive.openBox('Channels');
                      await channelsBox.clear();
                      await channelsBox.addAll(client.channels.map((channel) => channel.name));
                    },
                    icon: Icon(Icons.chat),
                    label: Text('Join #chatsen'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0 / 2.0)),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: Icon(Icons.alternate_email),
                    label: Text('Open mentions'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0 / 2.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
