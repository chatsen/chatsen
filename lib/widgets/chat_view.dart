import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/boxlistener.dart';
import '../tmi/channel/channel_message.dart';
import 'chat_message.dart';
import '/tmi/channel/channel.dart';
import '/tmi/channel/channel_messages.dart';

class ChatView extends StatefulWidget {
  final Channel channel;
  final bool Function(ChannelMessage message)? filter;
  final EdgeInsets? padding;

  const ChatView({
    super.key,
    required this.channel,
    this.filter,
    this.padding,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ScrollController scrollController = ScrollController();
  List<ChannelMessage>? scrollMessages;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        keys: const ['messageAppearance'],
        builder: (context, box) => BlocBuilder<ChannelMessages, List<ChannelMessage>>(
          bloc: widget.channel.channelMessages,
          buildWhen: (state1, state2) => scrollMessages == null,
          builder: (context, state) {
            var messages = (scrollMessages ?? state);
            if (widget.filter != null) messages = messages.where((element) => widget.filter!(element)).toList();
            return Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification && scrollMessages == null && scrollController.position.pixels > scrollController.position.minScrollExtent) {
                        scrollMessages = state;
                        setState(() {});
                      }
                      if (scrollNotification is ScrollEndNotification && scrollMessages != null && scrollController.position.pixels <= scrollController.position.minScrollExtent) {
                        scrollMessages = null;
                        setState(() {});
                      }
                      return true;
                    },
                    child: ListView.builder(
                      // padding: MediaQuery.of(context).padding.copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.0),
                      padding: (widget.padding ?? EdgeInsets.zero).copyWith(top: (widget.padding?.top ?? 0) + 8.0, bottom: (widget.padding?.bottom ?? 0) + 8.0),
                      reverse: true,
                      itemCount: messages.length,
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) => ChatMessage(
                        key: ObjectKey(messages.reversed.elementAt(index)),
                        message: messages.reversed.elementAt(index),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (scrollMessages != null)
                        Ink(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                          height: 32.0 + 24.0,
                          child: InkWell(
                            onTap: () {
                              scrollMessages = null;
                              setState(() {});
                              WidgetsBinding.instance.scheduleFrameCallback((_) {
                                scrollController.jumpTo(scrollController.position.minScrollExtent);
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Scroll to bottom',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onTertiaryContainer,
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
            );
          },
        ),
      );
}
