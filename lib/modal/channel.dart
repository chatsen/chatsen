import 'package:chatsen/tmi/channel/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/chatsen/chatsen_user.dart';
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
        ),
      );
}
