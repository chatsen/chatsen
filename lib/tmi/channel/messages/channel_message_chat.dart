import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../data/emote.dart';
import '../../../providers/twitch.dart';
import '../channel.dart';
import '../channel_message.dart';
import '/irc/message.dart' as irc;

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

class ChannelMessageChat extends ChannelMessage {
  irc.Message message;
  bool action = false;
  List<dynamic> splits = [];

  ChannelMessageChat({
    required this.message,
    required DateTime dateTime,
    Channel? channel,
  }) : super(
          dateTime: dateTime,
          channel: channel,
        ) {
    var messageText = message.parameters.skip(1).join(':');

    if (messageText.contains(RegExp('ACTION .*'))) action = true;
    if (action) messageText = messageText.substring('ACTION '.length, messageText.length - 1);

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
      print('Couldn\'t parse Twitch emote data: ${message.tags['emotes']} -> $e');
    }

    final emotes = (channel?.channelEmotes.state ?? []) + (channel?.client.globalEmotes.state ?? []);
    final textSplits = messageText.split(' ');
    for (final textSplit in textSplits) {
      var emote = emotes.firstWhereOrNull((emote) => emote.name == textSplit);
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
      if (emote != null) {
        splits.add(emote);
      } else {
        splits.add(textSplit);
      }
    }
  }
}
