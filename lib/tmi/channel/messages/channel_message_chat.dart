import 'dart:convert';
import 'dart:developer';

import 'package:chatsen/api/anonfiles/anonfiles.dart';
import 'package:chatsen/data/custom_badge.dart';
import 'package:chatsen/data/inline_url.dart';
import 'package:chatsen/tmi/channel/messages/channel_message_user.dart';
import 'package:chatsen/tmi/channel/messages/embeds/file_embed.dart';
import 'package:chatsen/tmi/channel/messages/embeds/image_embed.dart';
import 'package:chatsen/tmi/channel/messages/embeds/video_embed.dart';
import 'package:chatsen/tmi/user.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/emote.dart';
import '../../../data/message_trigger.dart';
import '../../../data/user_trigger.dart';
import '../../../providers/twitch.dart';
import '../../connection/connection_state.dart';
import '../channel_message.dart';
import '/irc/message.dart' as irc;
import 'channel_message_embeds.dart';
import 'channel_message_id.dart';

class TwitchEmoteInstance {
  final String code;
  final int start;
  final int end;

  TwitchEmoteInstance({
    required this.code,
    required this.start,
    required this.end,
  });
}

class ChannelMessageChatReplyInfo {
  String replyParentDisplayName; // SupDos
  String replyParentMsgBody; // peepoLeave
  String replyParentMsgId; // a11f6f0d-e4ad-4f61-a5b8-58a848ef2f7e
  String replyParentUserId; // 43983992
  String replyParentUserLogin; // supdos

  ChannelMessageChatReplyInfo({
    required this.replyParentDisplayName,
    required this.replyParentMsgBody,
    required this.replyParentMsgId,
    required this.replyParentUserId,
    required this.replyParentUserLogin,
  });
}

class ChannelMessageChatSubInfo {
  String systemMsg;
  bool msgParamWasGifted;

  ChannelMessageChatSubInfo({
    required this.systemMsg,
    required this.msgParamWasGifted,
  });
}

class ChannelMessageChat extends ChannelMessage with ChannelMessageUser, ChannelMessageEmbeds, ChannelMessageId {
  irc.Message message;
  bool action = false;
  List<dynamic> splits = [];
  List<CustomBadge> badges = [];
  String body = '';
  ChannelMessageChatReplyInfo? replyInfo;
  ChannelMessageChatSubInfo? subInfo;
  bool mentionned = false;
  bool blocked = false;

  ChannelMessageChat({
    required this.message,
    required super.dateTime,
    super.channel,
  }) {
    build();
  }

  void build() {
    badges.clear();
    splits.clear();
    embeds.clear();

    // TODO: Ensure there is always an id at this stage?
    id = message.tags['id']!;

    try {
      replyInfo = ChannelMessageChatReplyInfo(
        replyParentDisplayName: message.tags['reply-parent-display-name']!,
        replyParentMsgBody: message.tags['reply-parent-msg-body']!, //.split('\\s').skip(0).join('\\s'),
        replyParentMsgId: message.tags['reply-parent-msg-id']!,
        replyParentUserId: message.tags['reply-parent-user-id']!,
        replyParentUserLogin: message.tags['reply-parent-user-login']!,
      );
    } catch (e) {
      // ignore
    }

    try {
      subInfo = ChannelMessageChatSubInfo(
        systemMsg: message.tags['system-msg']!,
        msgParamWasGifted: message.tags['msg-param-was-gifted']! != 'false',
      );
    } catch (e) {
      // ignore
    }

    user = User(
      login: message.prefix!.split('!').first,
      displayName: message.tags['display-name'],
      id: message.tags['user-id'],
      color: (message.tags['color']?.isEmpty ?? true) ? null : Color(int.parse('FF${message.tags['color']!.substring(1)}', radix: 16)),
    );

    var messageText = message.parameters.skip(1).join(':');

    if (messageText.contains(RegExp('ACTION .*'))) action = true;
    if (action) messageText = messageText.substring('ACTION '.length, messageText.length - 1);

    // replace U+200D (ZERO WIDTH JOINER) with U+E0002
    // alternative regex for replacement: (?<!\U000E0002)\U000E0002
    final replacement = String.fromCharCodes(Runes('\u{e0002}'));
    final zeroWidthJoiner = String.fromCharCodes(Runes('\u{200d}'));
    messageText = messageText.replaceAll(replacement, zeroWidthJoiner);

    body = messageText;

    final messageRunes = messageText.runes.toList();

    try {
      final twitchEmotes = <TwitchEmoteInstance>[];
      for (final twitchEmoteData in (message.tags['emotes']?.split('/') ?? []).where((element) => element.isNotEmpty)) {
        final twitchEmoteCodeAndInstances = twitchEmoteData.split(':');
        final twitchEmoteCode = twitchEmoteCodeAndInstances.first;
        final twitchEmoteInstances = twitchEmoteCodeAndInstances.last.split(',').map((instance) => instance.split('-'));
        for (final twitchEmoteInstanceData in twitchEmoteInstances) {
          twitchEmotes.add(
            TwitchEmoteInstance(
              code: twitchEmoteCode,
              start: int.parse(twitchEmoteInstanceData.first),
              end: int.parse(twitchEmoteInstanceData.last),
            ),
          );
        }
      }

      twitchEmotes.sort((item, item2) => item2.start.compareTo(item.start));

      for (var twitchEmote in twitchEmotes) {
        messageRunes.replaceRange(twitchEmote.start, twitchEmote.end + 1, utf8.encode(' ${twitchEmote.code}|${String.fromCharCodes(messageRunes.getRange(twitchEmote.start, twitchEmote.end + 1))} '));
      }

      messageText = String.fromCharCodes(messageRunes).replaceAll(utf8.decode([0xF3, 0xA0, 0x80, 0x80]), '');
    } catch (e) {
      log('Couldn\'t parse Twitch emote data: ${message.tags['emotes']} -> $e');
    }

    final allBadges = (channel?.channelBadges.state ?? []) + (channel?.client.globalBadges.state ?? []);
    final twitchBadges = message.tags['badges']?.split(',') ?? [];
    for (final twitchBadgeId in twitchBadges) {
      final badge = allBadges.firstWhereOrNull((badge) => badge.id == twitchBadgeId);
      if (badge != null) badges.add(badge);
    }

    for (final badgeUsers in (channel?.client.globalUserBadges.state ?? [])) {
      if (badgeUsers.users.contains(user.id)) badges.add(badgeUsers.badge);
    }

    final emotes = (channel?.channelEmotes.state ?? []) + (channel?.client.globalEmotes.state ?? []);
    var textSplits = messageText.split(' ').where((split) => split.isNotEmpty);
    if (replyInfo != null) textSplits = textSplits.skip(1);

    for (final textSplit in textSplits) {
      var emote = emotes.firstWhereOrNull((emote) => (emote.code ?? emote.name) == textSplit);
      if (textSplit.startsWith('')) {
        final emoteData = textSplit.substring(1).split('|');
        emote = Emote(
          id: emoteData.first,
          mipmap: [
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/1.0',
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/2.0',
            'https://static-cdn.jtvnw.net/emoticons/v2/${emoteData.first}/default/dark/3.0',
          ],
          name: emoteData.last,
          provider: TwitchProvider(),
        );
      }

      final uri = Uri.tryParse(textSplit);
      final imageRegex = RegExp(r'\.(png|apng|gif|webp|jpg|jpeg)$');
      final videoRegex = RegExp(r'\.(webm|mp4)$');

      if (emote != null) {
        splits.add(emote);
      } else if (uri != null && uri.isAbsolute) {
        splits.add(InlineUrl(url: '$uri'));
        if (imageRegex.hasMatch('${uri.removeFragment()}')) {
          embeds.add(ImageEmbed(url: '$uri'));
        } else if (videoRegex.hasMatch('${uri.removeFragment()}')) {
          embeds.add(VideoEmbed(url: '$uri'));
        } else if (uri.host == 'anonfiles.com') {
          try {
            Anonfiles.getFileInfo(uri.path.split('/')[1]).then((fileInfo) {
              if (fileInfo == null) return;
              embeds.add(
                FileEmbed(
                  name: fileInfo.metadata.name,
                  url: fileInfo.url.short,
                  size: fileInfo.metadata.size.bytes,
                ),
              );
            });
            // ignore: empty_catches
          } catch (e) {}
        }
      } else {
        splits.add(textSplit);
      }
    }

    // Check whether the user got mentionned or if the message should be blocked
    mentionned = false;
    blocked = false;

    final receiver = channel?.client.receiver;
    if (receiver != null) {
      // Check user triggers
      final userTriggers = Hive.box('UserTriggers').values.cast<UserTrigger>();
      final userTrigger = userTriggers.firstWhereOrNull((element) => element.login.toLowerCase() == user.login?.toLowerCase());
      if (userTrigger != null) {
        switch (UserTriggerType.values[userTrigger.type]) {
          case UserTriggerType.mention:
            mentionned = true;
            break;
          case UserTriggerType.block:
            blocked = true;
            break;
        }
      }

      // Check message triggers
      final messageTriggers = Hive.box('MessageTriggers').values.cast<MessageTrigger>();
      final messageTrigger = messageTriggers.firstWhereOrNull((messageTrigger) {
        if (messageTrigger.enableRegex) {
          return RegExp(messageTrigger.pattern).hasMatch(body);
        } else {
          var pattern = messageTrigger.pattern;
          if (!messageTrigger.caseSensitive) {
            pattern = messageTrigger.pattern.toLowerCase();
            if (textSplits.length > 1) {
              return body.toLowerCase().contains(pattern);
            } else {
              return textSplits.whereType<String>().map((e) => e.toLowerCase()).any((split) => (split == pattern || split == '@$pattern' || split == '$pattern,' || split == '@$pattern,'));
            }
          } else {
            if (textSplits.length > 1) {
              return body.contains(pattern);
            } else {
              return textSplits.whereType<String>().any((split) => (split == pattern || split == '@$pattern' || split == '$pattern,' || split == '@$pattern,'));
            }
          }
        }
      });
      if (messageTrigger != null) {
        switch (MessageTriggerType.values[messageTrigger.type]) {
          case MessageTriggerType.mention:
            mentionned = true;
            break;
          case MessageTriggerType.block:
            blocked = true;
            break;
        }
      }

      if (receiver.state is ConnectionConnected) {
        final connectedState = (receiver.state as ConnectionConnected);
        blocked = blocked || connectedState.blockedUserIds.contains(user.id);
        mentionned = mentionned || textSplits.whereType<String>().map((e) => e.toLowerCase()).any((split) => (split == connectedState.twitchAccount.tokenData.login || split == '@${connectedState.twitchAccount.tokenData.login}' || split == '${connectedState.twitchAccount.tokenData.login},' || split == '@${connectedState.twitchAccount.tokenData.login},'));
      }
    }
  }
}
