import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

/// [HomeTab] is a widget that represents a channel as a simple tab.
class HomeTab extends StatelessWidget {
  final twitch.Client? client;
  final twitch.Channel channel;
  final Function refresh;

  const HomeTab({
    Key? key,
    required this.client,
    required this.channel,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${channel.name}'),
            Container(
              width: 32.0,
              height: 32.0,
              child: InkWell(
                onTap: () async {
                  client!.partChannels([channel]);
                  var channelsBox = await Hive.openBox('Channels');
                  await channelsBox.clear();
                  await channelsBox.addAll(client!.channels.map((channel) => channel.name));
                  refresh();
                },
                child: Icon(Icons.close),
              ),
            ),
          ],
        ),
      );
}
