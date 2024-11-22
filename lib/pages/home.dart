import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatsen/components/surface.dart';
import 'package:chatsen/modal/channel.dart';
import 'package:chatsen/widgets/browser/stream_container.dart';
import 'package:chatsen/widgets/cookies_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/modal.dart';
import '../modal/chatsen.dart';
import '../tmi/channel/channel.dart';
import '../tmi/client/client.dart';
import '../tmi/client/client_channels.dart';
import '../widgets/channel_view.dart';
import '../widgets/home_tab.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: preferredSize.height,
        child: Row(
          children: [
            Expanded(child: MoveWindow()),
            InkWell(
              child: SizedBox(
                height: preferredSize.height,
                width: preferredSize.height,
                child: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              onTap: () => appWindow.close(),
            ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight / 2.0);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => StreamContainer(
        child: BlocBuilder<ClientChannels, List<Channel>>(
          bloc: context.read<Client>().channels,
          builder: (context, state) {
            return DefaultTabController(
              length: 1 + state.length,
              child: Scaffold(
                // endDrawer: const NotificationsModal(),
                // backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.80),
                backgroundColor: Platform.isWindows ? Colors.transparent : null,
                appBar: Platform.isWindows ? const MyAppBar() : null,
                extendBody: true,
                extendBodyBehindAppBar: true,
                bottomNavigationBar: Surface(
                  // color: Theme.of(context).colorScheme.surface,
                  type: SurfaceType.surfaceVariant,
                  child: SafeArea(
                    top: false,
                    child: TabBar(
                      isScrollable: true,
                      tabs: [
                        GestureDetector(
                          onLongPress: () {
                            Modal.show(
                              context: context,
                              child: const ChatsenModal(),
                            );
                          },
                          child: const SizedBox(
                            height: 48.0,
                            child: Icon(Icons.home_outlined),
                          ),
                        ),
                        for (final channel in state)
                          GestureDetector(
                            onLongPress: () {
                              Modal.show(
                                context: context,
                                child: ChannelModal(channel: channel),
                              );
                            },
                            child: SizedBox(
                              height: 48.0,
                              child: Center(child: Text(channel.name)),
                            ),
                          ),
                        // const SizedBox(
                        //     // height: 48.0,
                        //     // child: Icon(Icons.info_outline),
                        //     ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    const HomeTab(),
                    for (final channel in state)
                      ChannelView(
                        channel: channel,
                      ),
                    // ConnectionLogsDisplay(),
                  ],
                ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () async {
                //     Modal.show(
                //       context: context,
                //       child: const ChatsenModal(),
                //     );
                //   },
                //   child: const Icon(Icons.settings),
                // ),
              ),
            );
          },
        ),
      );
}
