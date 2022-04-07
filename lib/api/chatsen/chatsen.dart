import 'dart:convert';

import 'package:http/http.dart' as http;

import 'chatsen_badge.dart';
import 'chatsen_user.dart';

class Chatsen {
  static Future<ChatsenUser> userWithViewers(String login) async {
    final response = await http.get(Uri.parse('https://api.chatsen.app/v1/channel/$login'));
    final responseJson = await json.decode(utf8.decode(response.bodyBytes));
    return ChatsenUser.fromJson(responseJson);
  }

  static Future<ChatsenUser> user(String login) async {
    final response = await http.get(Uri.parse('https://api.chatsen.app/v1/user/$login'));
    final responseJson = await json.decode(utf8.decode(response.bodyBytes));
    return ChatsenUser.fromJson(responseJson);
  }

  static Future<List<ChatsenBadge>> badges() async {
    final response = await http.get(Uri.parse('https://api.chatsen.app/v1/cosmetics'));
    final responseJson = await json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final badge in responseJson) ChatsenBadge.fromJson(badge),
    ];
  }
}
