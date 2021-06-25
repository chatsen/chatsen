import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:chatsen_resources/data.dart' as resources;
import 'package:chatsen_resources/user.dart' as resources;
import 'package:chatsen_resources/badge.dart' as resources;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class SevenTVBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  SevenTVBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    var response = await http.get(Uri.parse('https://api.7tv.app/v2/badges?user_identifier=twitch_id'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    var users = <String, List<twitch.Badge>>{};
    for (var badgeData in jsonResponse['badges']) {
      for (var userId in badgeData['users']) {
        if (users[userId] == null) users[userId] = <twitch.Badge>[];
        users[userId]!.add(
          twitch.Badge(
            title: badgeData['tooltip'],
            description: null,
            id: badgeData['id'],
            mipmap: [
              for (var url in badgeData['urls']) url.last,
            ],
            name: badgeData['id'],
            tag: badgeData['id'],
          ),
        );
      }
    }

    emit(users);
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
