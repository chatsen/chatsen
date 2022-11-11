import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/emote.dart';
import 'emote_provider.dart';
import 'provider.dart';

class EmojiProvider extends Provider with EmoteProvider {
  @override
  String get name => 'Emoji';

  @override
  String? get description => null;

  @override
  Future<List<Emote>> globalEmotes() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji.json'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final emojiData in responseJson.where((entry) => entry['has_img_twitter'] == true))
        Emote(
          id: emojiData['unified'],
          code: emojiData['unified'].split('-').map((x) => String.fromCharCode(int.parse(x, radix: 16))).join(),
          name: emojiData['short_name'],
          mipmap: [
            'https://raw.githubusercontent.com/iamcal/emoji-data/master/img-twitter-72/${emojiData['image']}',
          ],
          provider: this,
        ),
    ];
  }

  @override
  Future<List<Emote>> channelEmotes(String uid) async {
    return [];
  }

  @override
  String? emoteUrl(String id) => null;
}
