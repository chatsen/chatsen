import 'package:chatsen/widgets/channel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/tile.dart';
import '../tmi/channel/messages/channel_message_chat.dart';
import '../widgets/chat_message.dart';

class MessageModal extends StatelessWidget {
  final ChannelMessageChat message;
  final ChannelViewState? channelViewState;

  const MessageModal({
    super.key,
    required this.message,
    this.channelViewState,
  });

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ChatMessage(message: message),
          ),
          Tile(
            title: AppLocalizations.of(context)!.reply,
            prefix: const Icon(Icons.reply_outlined),
            onTap: () {
              Navigator.of(context).pop();
              channelViewState?.setReplyChannelMessageChat(message);
            },
          ),
          Tile(
            title: AppLocalizations.of(context)!.copyText,
            subtitle: AppLocalizations.of(context)!.copyTextSubtitle,
            prefix: const Icon(Icons.copy_rounded),
            onTap: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: message.body));
            },
            onLongPress: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: '${message.dateTime.hour}:${message.dateTime.minute.toString().padLeft(2, '0')} ${message.user.displayName}: ${message.body}'));
            },
          ),
          Tile(
            title: AppLocalizations.of(context)!.deleteMessage,
            prefix: const Icon(Icons.delete_outline_outlined),
            onTap: () async {
              Navigator.of(context).pop();
              await message.channel?.send('/delete ${message.id}');
            },
          ),
          Tile(
            title: AppLocalizations.of(context)!.mentionUser,
            prefix: const Icon(Icons.alternate_email_outlined),
            onTap: () {
              Navigator.of(context).pop();
              channelViewState?.addSplit('@${message.user.login}');
            },
          ),
          Tile(
            title: AppLocalizations.of(context)!.copyMessageId,
            prefix: const Icon(Icons.medical_information_outlined),
            onTap: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: message.id));
            },
          ),
        ],
      );
}
