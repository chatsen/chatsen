import 'package:chatsen/modal/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/modal.dart';
import '../modal/chatsen.dart';
import '../tmi/channel/channel.dart';
import '../tmi/client/client.dart';
import '../tmi/client/client_channels.dart';
import '../widgets/channel_view.dart';
import '../widgets/home_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<ClientChannels, List<Channel>>(
        bloc: context.read<Client>().channels,
        builder: (context, state) {
          return DefaultTabController(
            length: 1 + state.length,
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              bottomNavigationBar: Material(
                color: Theme.of(context).colorScheme.primaryContainer,
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
      );
}
