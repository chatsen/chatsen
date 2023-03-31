import 'dart:convert';

import '/api/chatsen_static/chatsen_static_emote.dart';
import 'package:http/http.dart' as http;

class ChatsenStatic {
  static Future<List<ChatsenStaticEmote>> staticEmotes() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/chatsen/resources/master/emotes/emotes.json'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final emote in responseJson) ChatsenStaticEmote.fromJson(emote),
    ];
  }
}
