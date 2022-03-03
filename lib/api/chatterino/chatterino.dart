import 'dart:convert';

import 'package:http/http.dart' as http;

import 'chatterino_badge.dart';

class Chatterino {
  static Future<List<ChatterinoBadge>> badges() async {
    final response = await http.get(Uri.parse('https://api.chatterino.com/badges'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final badge in responseJson) ChatterinoBadge.fromJson(badge),
    ];
  }
}
