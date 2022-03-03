import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tmi/channel/channel.dart';
import '../tmi/channel/channel_state.dart';
import '/tmi/log.dart';
import '/tmi/logs.dart';
import '/irc/message.dart' as irc;
import '/tmi/client/client.dart';
import '/tmi/channel/channel_event.dart';
import '/tmi/client/client_channels.dart';

class ConnectionLogEntry extends StatelessWidget {
  final Log log;

  const ConnectionLogEntry({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: (log.data is irc.Message) ? (log.data as irc.Message).raw : '${log.data}',
                  style: TextStyle(
                    color: log.outgoing ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ConnectionLogsDisplay extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final TextEditingController channelController = TextEditingController();

  ConnectionLogsDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<Logs, List<Log>>(
        bloc: context.read<Client>().receiver.logs,
        builder: (BuildContext context, state) => SafeArea(
          child: Column(
            children: [
              TextField(
                controller: channelController,
                onSubmitted: (text) {
                  context.read<Client>().channels.join('#$text');
                  channelController.clear();
                },
              ),
              BlocBuilder<ClientChannels, List<Channel>>(
                  bloc: context.read<Client>().channels,
                  builder: (context, state) {
                    return Material(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: SizedBox(
                        height: 48.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final channel in state)
                              BlocBuilder<Channel, ChannelState>(
                                bloc: channel,
                                builder: (context, channelState) => InkWell(
                                  onTap: () {
                                    final client = context.read<Client>();
                                    client.receiver.send('JOIN ${channel.name}');
                                    client.channels.state.firstWhereOrNull((channelSelect) => channelSelect.name == channel.name)?.add(ChannelJoin(client.receiver, client.transmitter));
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('${channel.name}\n${channelState.runtimeType.toString().substring(7)}'),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: state.length,
                  itemBuilder: (BuildContext context, int index) => ConnectionLogEntry(
                    key: ObjectKey(state.reversed.elementAt(index)),
                    log: state.reversed.elementAt(index),
                  ),
                ),
              ),
              TextField(
                controller: controller,
                onSubmitted: (text) {
                  context.read<Client>().receiver.send(text);
                  controller.clear();
                },
              ),
            ],
          ),
        ),
      );
}
