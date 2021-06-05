import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/Components/ChannelJoinModal.dart';
import '/Components/HomeTab.dart';
import '/Components/WhisperJoinModal.dart';
import '/Components/WhisperTab.dart';
import '/Views/Chat.dart';

class WhispersPage extends StatefulWidget {
  final twitch.Client? client;

  const WhispersPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _WhispersPageState createState() => _WhispersPageState();
}

class _WhispersPageState extends State<WhispersPage> implements twitch.Listener {
  @override
  void initState() {
    widget.client!.listeners.add(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.client!.listeners.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: widget.client!.transmitters[null]!.whispers.length,
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Builder(
            builder: (context) => TabBarView(
              children: [
                for (var channel in widget.client!.transmitters[null]!.whispers)
                  ChatView(
                    client: widget.client,
                    channel: channel,
                  ),
              ],
            ),
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
                          child: Container(
                            child: Icon(Icons.arrow_back_ios_new),
                            height: 32.0,
                            width: 32.0,
                          ),
                          onTap: () async => Navigator.of(context).pop(),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: TabBar(
                            labelPadding: EdgeInsets.only(left: 8.0),
                            isScrollable: true,
                            tabs: widget.client!.transmitters[null]!.whispers
                                .map(
                                  (channel) => WhisperTab(
                                    client: widget.client,
                                    channel: channel,
                                    refresh: () => setState(() {}),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Add/Join a whisper',
                        child: InkWell(
                          child: Container(
                            child: Icon(Icons.add),
                            height: 32.0,
                            width: 32.0,
                          ),
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: WhisperJoinModal(
                                    client: widget.client,
                                    refresh: () => setState(() {}),
                                  ),
                                ),
                              ),
                              // backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void onChannelStateChange(twitch.Channel channel, twitch.ChannelState state) {}

  @override
  void onConnectionStateChange(twitch.Connection connection, twitch.ConnectionState state) {}

  @override
  void onHistoryLoaded(twitch.Channel channel) {}

  @override
  void onMessage(twitch.Channel? channel, twitch.Message message) {}

  @override
  void onWhisper(twitch.Channel channel, twitch.Message message) {
    setState(() {});
  }
}
