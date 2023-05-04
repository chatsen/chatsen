import 'package:chatsen/api/twitch/twitch.dart';
import 'package:chatsen/tmi/channel/messages/channel_message_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/chatsen/chatsen.dart';
import '../api/chatsen/chatsen_user.dart';
import '../tmi/channel/channel.dart';
import '../tmi/channel/messages/channel_message_chat.dart';
import '../widgets/chat_view.dart';
import 'components/user_modal_header.dart';

// ignore: must_be_immutable
class UserModal extends StatelessWidget {
  late Future<ChatsenUser> future;
  final Channel? channel;

  UserModal({
    super.key,
    required String login,
    this.channel,
  }) {
    future = Chatsen.user(login);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ChatsenUser>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<ChatsenUser> snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView(
            shrinkWrap: true,
            children: [
              UserModalHeader(user: snapshot.data!),
              if (channel != null)
                Material(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Row(
                    children: [
                      Tooltip(
                        message: AppLocalizations.of(context)!.ban,
                        child: IconButton(
                          icon: const Icon(
                            Icons.block_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            try {
                              await Twitch.ban(
                                channel!.client.transmitter.twitchAccount!.tokenData,
                                broadcasterId: channel!.id!,
                                moderatorId: channel!.client.transmitter.twitchAccount!.tokenData.userId!,
                                userId: snapshot.data!.id,
                              );
                            } catch (e) {
                              print(e);
                              // channel.channelMessages.add(ChannelMessageNotice(message: message, dateTime: dateTime))
                            }
                            // channel?.send('/ban ${snapshot.data!.login}'),
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (final time in {
                                  '1s': const Duration(seconds: 1),
                                  '30s': const Duration(seconds: 30),
                                  '1m': const Duration(minutes: 1),
                                  '5m': const Duration(minutes: 5),
                                  '30m': const Duration(minutes: 30),
                                  '1h': const Duration(hours: 1),
                                  '1d': const Duration(days: 1),
                                  '1w': const Duration(days: 7),
                                }.entries)
                                  Tooltip(
                                    message: AppLocalizations.of(context)!.timeoutUserForDuration(time.value.toString().split('.').first),
                                    child: TextButton(
                                      child: Text(time.key),
                                      onPressed: () async {
                                        try {
                                          await Twitch.ban(
                                            channel!.client.transmitter.twitchAccount!.tokenData,
                                            broadcasterId: channel!.id!,
                                            moderatorId: channel!.client.transmitter.twitchAccount!.tokenData.userId!,
                                            userId: snapshot.data!.id,
                                            duration: time.value.inSeconds,
                                          );
                                        } catch (e) {
                                          print(e);
                                          // channel.channelMessages.add(ChannelMessageNotice(message: message, dateTime: dateTime))
                                        }
                                        // channel?.send('/timeout ${snapshot.data!.login} ${time.value.inSeconds}'),
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: AppLocalizations.of(context)!.unban,
                        child: IconButton(
                          icon: const Icon(
                            Icons.block_rounded,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            try {
                              await Twitch.unban(
                                channel!.client.transmitter.twitchAccount!.tokenData,
                                broadcasterId: channel!.id!,
                                moderatorId: channel!.client.transmitter.twitchAccount!.tokenData.userId!,
                                userId: snapshot.data!.id,
                              );
                            } catch (e) {
                              print(e);
                              // channel.channelMessages.add(ChannelMessageNotice(message: message, dateTime: dateTime))
                            }
                            // channel?.send('/unban ${snapshot.data!.login}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (channel != null)
                SizedBox(
                  width: double.infinity,
                  height: 350.0,
                  child: ChatView(
                    channel: channel!,
                    filter: (message) {
                      if (message is! ChannelMessageChat) return false;
                      // TODO: change when proper user storage is done
                      return message.message.prefix?.split('!').first == snapshot.data!.login;
                    },
                  ),
                ),
            ],
          );
        },
      );
}
