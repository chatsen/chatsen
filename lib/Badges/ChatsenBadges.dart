import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:chatsen_resources/data.dart' as resources;
import 'package:chatsen_resources/user.dart' as resources;
import 'package:chatsen_resources/badge.dart' as resources;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

// class ChatsenBadges extends Cubit<resources.Data?> {
//   ChatsenBadges() : super(null) {
//     refresh();
//   }

//   void refresh() async {
//     var response = await http.get(Uri.parse('https://raw.githubusercontent.com/chatsen/resources/master/assets/data.json')); // https://cdn.jsdelivr.net/gh/chatsen/resources/assets/data.json'));
//     var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
//     emit(resources.Data.fromJson(jsonResponse));
//   }

//   List<twitch.Badge> getBadgesForUser(String id) {
//     var badges = <twitch.Badge>[];
//     var matchedUser = List<resources.User?>.from(state!.users).firstWhere((element) => element!.id == id, orElse: () => null);
//     if (matchedUser == null) return [];
//     for (var badgeData in matchedUser.badges) {
//       var matchedBadge = List<resources.Badge?>.from(state!.badges).firstWhere((element) => element!.name == badgeData.badgeName, orElse: () => null);
//       if (matchedBadge == null) continue;
//       badges.add(twitch.Badge());
//     }
//     return badges;
//   }
// }

class ChatsenBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  ChatsenBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    try {
      var response = await http.get(Uri.parse('https://raw.githubusercontent.com/chatsen/resources/master/assets/data.json')); // https://cdn.jsdelivr.net/gh/chatsen/resources/assets/data.json'));
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      var data = resources.Data.fromJson(jsonResponse);
      emit({
        for (var userData in data.users)
          userData.id: [
            for (var badgeData in userData.badges.map((x) => data.badges.firstWhere((element) => element.name == x.badgeName)).toList())
              twitch.Badge(
                title: badgeData.title,
                description: badgeData.description,
                id: badgeData.name,
                mipmap: [badgeData.image],
                name: badgeData.name,
                tag: badgeData.name,
              ),
          ],
      });
    } catch (e) {
      print(e);
    }
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
