import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:hive/hive.dart';

/// [WhisperTab] is a widget that represents a channel as a simple tab.
class WhisperTab extends StatelessWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;
  final Function refresh;

  const WhisperTab({
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
            Text('${channel!.name}'),
            Container(
              width: 32.0,
              height: 32.0,
              child: InkWell(
                onTap: () async {
                  client!.transmitters[null]!.partWhisper(channel!.name!);
                  refresh();
                },
                child: Icon(Icons.close),
              ),
            ),
          ],
        ),
      );
}
