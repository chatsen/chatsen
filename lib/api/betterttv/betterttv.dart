import 'dart:convert';

import 'package:chatsen/api/betterttv/betterttv_badge.dart';
import 'package:http/http.dart' as http;

import '/api/betterttv/betterttv_emote.dart';
import 'betterttv_user.dart';

class BetterTTV {
  static Future<List<BetterTTVEmote>> globalEmotes() async {
    final response = await http.get(Uri.parse('https://api.betterttv.net/3/cached/emotes/global'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final emote in responseJson) BetterTTVEmote.fromJson(emote),
    ];
  }

  static Future<BetterTTVUser> user(String uid) async {
    final response = await http.get(Uri.parse('https://api.betterttv.net/3/cached/users/twitch/$uid'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return BetterTTVUser.fromJson(responseJson);
  }

  static Future<List<BetterTTVBadge>> badges() async {
    final response = await http.get(Uri.parse('https://api.betterttv.net/3/cached/badges'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final badge in responseJson) BetterTTVBadge.fromJson(badge),
    ];
  }
}
