import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:chatsen_resources/data.dart' as resources;
import 'package:chatsen_resources/user.dart' as resources;
import 'package:chatsen_resources/badge.dart' as resources;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class DankChatBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  DankChatBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    try {
      var response = await http.get(Uri.parse('https://flxrs.com/api/badges'));
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      var users = <String, List<twitch.Badge>>{};
      for (var badgeData in jsonResponse) {
        for (var userId in badgeData['users']) {
          if (users[userId] == null) users[userId] = <twitch.Badge>[];
          users[userId]!.add(
            twitch.Badge(
              title: badgeData['type'],
              description: null,
              id: base64Encode(badgeData['type'].codeUnits),
              mipmap: [
                badgeData['url'],
              ],
              name: base64Encode(badgeData['type'].codeUnits),
              tag: base64Encode(badgeData['type'].codeUnits),
            ),
          );
        }
      }

      emit(users);
    } catch (e) {
      print(e);
    }
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
