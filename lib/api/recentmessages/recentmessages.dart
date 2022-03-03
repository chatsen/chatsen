import 'dart:convert';

import 'package:http/http.dart' as http;

class RecentMessages {
  static Future<List<String>> channel(String channelName) async {
    final response = await http.get(Uri.parse('https://recent-messages.robotty.de/api/v2/recent-messages/$channelName'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return List<String>.from(responseJson['messages']);
  }
}
