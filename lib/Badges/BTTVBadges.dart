import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:chatsen_resources/data.dart' as resources;
import 'package:chatsen_resources/user.dart' as resources;
import 'package:chatsen_resources/badge.dart' as resources;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class BTTVBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  BTTVBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    try {
      var response = await http.get(Uri.parse('https://api.betterttv.net/3/cached/badges'));
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      var users = <String, List<twitch.Badge>>{};
      for (var badgeData in jsonResponse) {
        var userId = badgeData['providerId'];
        // for (var userId in badgeData['usernames']) {
        if (users[userId] == null) users[userId] = <twitch.Badge>[];
        users[userId]!.add(
          twitch.Badge(
            title: badgeData['badge']['description'],
            description: null,
            id: badgeData['id'],
            mipmap: [
              badgeData['badge']['svg'],
            ],
            name: badgeData['id'],
            tag: badgeData['id'],
          ),
        );

        // }
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
