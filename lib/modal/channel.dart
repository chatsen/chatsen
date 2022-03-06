import 'package:chatsen/tmi/channel/channel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tmi/client/client.dart';

class ChannelModal extends StatelessWidget {
  final Channel channel;

  const ChannelModal({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(24.0),
                  child: const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.close),
                  ),
                ),
                const Spacer(),
                Text(
                  channel.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 40.0,
                  height: 40.0,
                ),
              ],
            ),
          ),
          // const Separator(),
          InkWell(
            onTap: () async {
              context.read<Client>().channels.part(channel);
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: const [
                  SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.delete_forever_outlined),
                  ),
                  SizedBox(width: 16.0),
                  Text('Leave channel'),
                ],
              ),
            ),
          ),
        ],
      );
}
