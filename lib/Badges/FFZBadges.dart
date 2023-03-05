import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class FFZBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  FFZBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    var response = await http.get(Uri.parse('https://api.frankerfacez.com/v1/badges'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    var badges = <String, twitch.Badge>{
      for (var badgeData in jsonResponse['badges'])
        badgeData['id'].toString(): twitch.Badge(
          title: badgeData['title'],
          description: null,
          id: badgeData['id'].toString(),
          mipmap: [
            for (var url in badgeData['urls'].values) url.startsWith('http') ? url : 'https:$url',
          ],
          name: badgeData['name'],
          tag: badgeData['name'],
          color: badgeData['color'].substring(1),
        ),
    };

    var users = <String, List<twitch.Badge>>{};
    for (var userGroupData in jsonResponse['users'].entries) {
      for (var user in userGroupData.value) {
        if (users[user] == null) users[user] = <twitch.Badge>[];
        users[user]!.add(badges[userGroupData.key]!);
      }
    }

    emit(users);
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
