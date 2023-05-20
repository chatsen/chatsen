import 'dart:math';

import 'package:chatsen/tmi/channel/messages/channel_message_chat.dart';
import 'package:chatsen/widgets/avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/boxlistener.dart';
import '../components/surface.dart';
import '../data/notifications_cubit.dart';
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
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<ChannelMessage>? scrollMessages;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
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
            var messages = (scrollMessages ?? state).reversed;
            if (scrollMessages != null && searchController.text.isNotEmpty) messages = messages.where((element) => (element is ChannelMessageChat && '${(element.user.displayName ?? element.user.login)?.toLowerCase()}: ${element.body.toLowerCase()}'.contains(searchController.text.toLowerCase()))).toList();
            if (widget.filter != null) messages = messages.where((element) => widget.filter!(element)).toList();
            return Stack(
              children: [
                Positioned.fill(
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
                      itemBuilder: (BuildContext context, int index) {
                        return ChatMessage(
                          key: ObjectKey(messages.elementAt(index)),
                          message: messages.elementAt(index),
                        );
                      },
                    ),
                  ),
                ),
                // Material(
                //   color: Theme.of(context).colorScheme.primaryContainer,
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       if (scrollMessages != null)
                //         Ink(
                //           color: Theme.of(context).colorScheme.tertiaryContainer,
                //           height: 32.0 + 24.0,
                //           child: InkWell(
                //             onTap: () {
                //               scrollMessages = null;
                //               setState(() {});
                //               WidgetsBinding.instance.scheduleFrameCallback((_) {
                //                 scrollController.jumpTo(scrollController.position.minScrollExtent);
                //               });
                //             },
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Icons.arrow_downward_rounded,
                //                   color: Theme.of(context).colorScheme.onTertiaryContainer,
                //                 ),
                //                 const SizedBox(width: 4.0),
                //                 Text(
                //                   AppLocalizations.of(context)!.scrollToBottom,
                //                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                //                         color: Theme.of(context).colorScheme.onTertiaryContainer,
                //                       ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: scrollMessages != null ? 1.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Surface(
                              borderRadius: BorderRadius.circular(128.0),
                              // color: Colors.white,
                              type: SurfaceType.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    isDense: true,
                                  ),
                                  onChanged: (text) => setState(() {}),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.filter == null)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: (scrollMessages != null || BlocProvider.of<NotificationsCubit>(context).state.unread > 0) ? 1.0 : 0.0,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
                            child: AvatarButton(),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: scrollMessages != null ? 1.0 : 0.0,
                    child: Surface(
                      onTap: () {
                        scrollMessages = null;
                        setState(() {});
                        WidgetsBinding.instance.scheduleFrameCallback((_) {
                          scrollController.jumpTo(scrollController.position.minScrollExtent);
                        });
                        searchController.text = '';
                      },
                      borderRadius: BorderRadius.circular(128.0),
                      type: SurfaceType.tertiary,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Transform.rotate(
                          angle: 90 * pi / 180,
                          child: const Icon(Icons.chevron_right_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
