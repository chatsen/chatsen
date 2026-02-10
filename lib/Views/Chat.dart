import 'dart:io';

import '/BlockedUsers/BlockedUsersCubit.dart';
import '/Settings/Settings.dart';
import '/Settings/SettingsState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Components/ChatInputBox.dart';
import '/Components/ChatMessage.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/Components/UI/WidgetBlur.dart';
import '/StreamOverlay/StreamOverlayBloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';

/// The [ChatView] widget is a view that renders the messages associated to a channel with regards to the given client.
class ChatView extends StatefulWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;
  final bool shadow;
  // final Function(String)? addText;

  const ChatView({
    Key? key,
    required this.client,
    required this.channel,
    this.shadow = false,
    // this.addText,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> implements twitch.Listener {
  var gkey = GlobalKey<ChatInputBoxState>();
  bool shouldScroll = true;
  ScrollController? scrollController;
  double? scrollPosition;

  void scrollToEnd() {
    scrollController!.jumpTo(0);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController!.jumpTo(0);
    });
  }

  @override
  void initState() {
    scrollController = ScrollController();
    widget.client?.listeners.add(this);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    widget.client?.listeners.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                if (shouldScroll != false) {
                  shouldScroll = false;
                  setState(() {});
                }
              } else if (scrollNotification is ScrollUpdateNotification || scrollNotification is ScrollEndNotification) {
                if (scrollController!.position.pixels == scrollController!.position.minScrollExtent && shouldScroll != true) {
                  shouldScroll = true;
                  setState(() {});
                }
              }
              return true;
            },
            child: BlocBuilder<Settings, SettingsState>(
              builder: (context, state) {
                var i = 0;
                var blockedUsers = List<String>.from(BlocProvider.of<BlockedUsersCubit>(context).state).map((element) => element.toLowerCase()).toList();
                return ListView(
                  reverse: true,
                  controller: scrollController,
                  padding: MediaQuery.of(context).padding + (Platform.isMacOS ? EdgeInsets.only(top: 26.0) : EdgeInsets.zero) + EdgeInsets.only(bottom: (kDebugMode || widget.channel?.transmitter?.credentials?.token != null ? (36.0 + 4.0) : 0.0) + 8.0, top: 8.0),
                  children: [
                    for (var message in widget.channel!.messages.where((element) => !blockedUsers.contains(element.user?.login?.toLowerCase()))) ...[
                      if (state is SettingsLoaded && state.messageLines)
                        Container(
                          color: Theme.of(context).dividerColor,
                          height: 1.0,
                        ),
                      ChatMessage(
                        key: ObjectKey(message),
                        backgroundColor: state is SettingsLoaded && state.messageAlternateBackground && (i++ % 2 == 0) ? Theme.of(context).dividerColor : null,
                        message: message,
                        shadow: widget.shadow,
                        gkey: gkey,
                      ),
                    ],
                  ].reversed.toList(),
                );
              },
            ),
          ),
        ),
        if ((Platform.isMacOS ? 0.0 : MediaQuery.of(context).padding.top) > 0.0 && (MediaQuery.of(context).size.aspectRatio > 1.0 ? true : BlocProvider.of<StreamOverlayBloc>(context).state is StreamOverlayClosed))
          WidgetBlur(
            child: Material(
              color: Theme.of(context).canvasColor.withAlpha(196),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // height: Platform.isMacOS ? 26.0 : MediaQuery.of(context).padding.top,
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!shouldScroll)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: WidgetBlur(
                    borderRadius: BorderRadius.circular(32.0),
                    child: Material(
                      color: Theme.of(context).colorScheme.surface.withAlpha(196),
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor.withAlpha(16),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async => scrollToEnd(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.primary),
                                SizedBox(width: 8.0),
                                Text(
                                  'Resume scrolling',
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // icon:
                      // onPressed: () async => scrollToEnd(), child: null,
                    ),
                  ),
                ),
              WidgetBlur(
                child: Material(
                  color: Theme.of(context).colorScheme.surface.withAlpha(196),
                  child: ChatInputBox(
                    key: gkey,
                    client: widget.client,
                    channel: widget.channel,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onChannelStateChange(twitch.Channel channel, twitch.ChannelState state) {
    if (channel != widget.channel) return;
    setState(() {});
  }

  @override
  void onConnectionStateChange(twitch.Connection connection, twitch.ConnectionState state) {}

  @override
  void onMessage(twitch.Channel? channel, twitch.Message message) {
    if (channel != widget.channel || !shouldScroll) return;
    setState(() {});
  }

  @override
  void onHistoryLoaded(twitch.Channel channel) {
    if (channel != widget.channel || !shouldScroll) return;
    setState(() {});
  }

  @override
  void onWhisper(twitch.Channel channel, twitch.Message message) {
    if (channel != widget.channel || !shouldScroll) return;
    setState(() {});
  }
}




            // if (scrollNotification is ScrollStartNotification) {
            //   scrollPosition = scrollController.position.pixels;
            // } else if (scrollNotification is ScrollUpdateNotification) {
            //   if (scrollController.position.pixels < scrollPosition && shouldScroll != false) {
            //     shouldScroll = false;
            //     setState(() {});
            //   }
            //   scrollPosition = scrollController.position.pixels;
            // } else if (scrollNotification is ScrollEndNotification) {
            //   if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && shouldScroll != true) {
            //     shouldScroll = true;
            //     setState(() {});
            //   }
            //   scrollPosition = null;
            // }

            /*
if (shouldScroll) {
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   if (scrollController.position != null && shouldScroll) {
      //     scrollController.jumpTo(
      //       scrollController.position.maxScrollExtent,
      //       // curve: Curves.linear,
      //       // duration: const Duration(milliseconds: 250),
      //     );
      //   }
      // });
      // scrollController.jumpTo(
      // -10, //scrollController.position.minScrollExtent,
      // curve: Curves.linear,
      // duration: const Duration(milliseconds: 250),
      // );
    }
            */
