import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Components/ChatInputBox.dart';
import '/Components/ChatMessage.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:flutter_material_next/WidgetBlur.dart';
import '/StreamOverlay/StreamOverlayBloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';

/// The [ChatView] widget is a view that renders the messages associated to a channel with regards to the given client.
class ChatView extends StatefulWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;

  const ChatView({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> implements twitch.Listener {
  bool shouldScroll = true;
  ScrollController? scrollController;
  double? scrollPosition;

  void scrollToEnd() {
    scrollController!.jumpTo(0);
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      scrollController!.jumpTo(0);
    });
  }

  @override
  void initState() {
    scrollController = ScrollController();
    widget.client?.listeners?.add(this);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    widget.client?.listeners?.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
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
          child: ListView(
            reverse: true,
            controller: scrollController,
            padding: MediaQuery.of(context).padding + (Platform.isMacOS ? EdgeInsets.only(top: 26.0) : EdgeInsets.zero) + EdgeInsets.only(bottom: 32.0 + 8.0, top: 8.0),
            children: [
              for (var message in widget.channel!.messages)
                ChatMessage(
                  message: message,
                ),
            ].reversed.toList(),
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
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.arrow_downward),
                    // mini: true,
                    label: Text('Resume scrolling'),
                    onPressed: () async => scrollToEnd(),
                  ),
                ),
              WidgetBlur(
                child: Material(
                  color: Theme.of(context).canvasColor.withAlpha(196),
                  child: ChatInputBox(
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
