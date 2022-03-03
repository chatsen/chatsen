import 'dart:convert';

import 'package:http/http.dart' as http;

import 'chatsen_badge.dart';

class Chatsen {
  static Future<List<ChatsenBadge>> badges() async {
    final response = await http.get(Uri.parse('https://api.chatsen.app/list'));
    final responseJson = await json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final badge in responseJson) ChatsenBadge.fromJson(badge),
    ];
  }
}
