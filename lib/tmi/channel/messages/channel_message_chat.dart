import 'dart:convert';
import 'dart:developer';

import 'package:chatsen/api/anonfiles/anonfiles.dart';
import 'package:chatsen/data/badge.dart';
import 'package:chatsen/data/inline_url.dart';
import 'package:chatsen/tmi/channel/messages/channel_message_user.dart';
import 'package:chatsen/tmi/channel/messages/embeds/file_embed.dart';
import 'package:chatsen/tmi/channel/messages/embeds/image_embed.dart';
import 'package:chatsen/tmi/channel/messages/embeds/video_embed.dart';
import 'package:chatsen/tmi/user.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../data/emote.dart';
import '../../../providers/twitch.dart';
import '../channel.dart';
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

class ChannelMessageChat extends ChannelMessage with ChannelMessageUser, ChannelMessageEmbeds, ChannelMessageId {
  irc.Message message;
  bool action = false;
  List<dynamic> splits = [];
  List<Badge> badges = [];
  String body = '';

  ChannelMessageChat({
    required this.message,
    required DateTime dateTime,
    Channel? channel,
  }) : super(
          dateTime: dateTime,
          channel: channel,
        ) {
    build();
  }

  void build() {
    badges.clear();
    splits.clear();
    embeds.clear();

    // TODO: Ensure there is always an id at this stage?
    id = message.tags['id']!;

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

    final emotes = (channel?.channelEmotes.state ?? []) + (channel?.client.globalEmotes.state ?? []);
    final textSplits = messageText.split(' ').where((split) => split.isNotEmpty);
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
  }
}
