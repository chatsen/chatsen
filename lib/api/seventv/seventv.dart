import 'dart:convert';

import 'package:http/http.dart' as http;

import 'seventv_emote.dart';

class SevenTV {
  static Future<List<SevenTVEmote>> globalEmotes() async {
    final response = await http.get(Uri.parse('https://api.7tv.app/v2/emotes/global'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final emote in responseJson) SevenTVEmote.fromJson(emote),
    ];
  }

  static Future<List<SevenTVEmote>> channelEmotes(String uid) async {
    final response = await http.get(Uri.parse('https://api.7tv.app/v2/users/$uid/emotes'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final emote in responseJson) SevenTVEmote.fromJson(emote),
    ];
  }
}
