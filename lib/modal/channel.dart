import 'package:chatsen/tmi/channel/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/chatsen/chatsen_user.dart';
import '../components/tile.dart';
import '../data/browser_state.dart';
import '../tmi/channel/channel_info.dart';
import '../tmi/client/client.dart';
import 'components/user_modal_header.dart';

class ChannelModal extends StatelessWidget {
  final Channel channel;

  const ChannelModal({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<ChannelInfo, ChatsenUser?>(
        bloc: channel.channelInfo,
        builder: (context, state) => ListView(
          shrinkWrap: true,
          children: [
            if (state != null) UserModalHeader(user: state),
            // https://player.twitch.tv/?channel=forsen&enableExtensions=true&muted=true&parent=chatsen.app&player=popout&volume=1.0
            Tile(
              title: 'Play/Stop stream',
              onTap: () {
                final browserState = BlocProvider.of<BrowserState>(context);
                browserState.emit([
                  ...browserState.state,
                  'https://player.twitch.tv/?channel=${channel.name.substring(1)}&enableExtensions=true&muted=true&parent=chatsen.app&player=popout&volume=1.0',
                ]);
              },
            ),
            Tile(
              title: 'Leave channel',
              prefix: const Icon(Icons.delete_forever_outlined),
              onTap: () async {
                context.read<Client>().channels.part(channel);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
