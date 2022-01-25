import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class HomiesBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  HomiesBadges() : super({}) {
    refresh();
  }

  void refresh() async {
    Map<String, List<twitch.Badge>> badges = {};

    var response = await http.get(Uri.parse('https://chatterinohomies.com/api/badges/list')); // https://cdn.jsdelivr.net/gh/chatsen/resources/assets/data.json'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    for (var badgeData in jsonResponse['badges']) {
      badges['${badgeData['userId']}'] ??= [];
      badges['${badgeData['userId']}']!.add(
        twitch.Badge(
          title: badgeData['tooltip'],
          description: null,
          id: badgeData['badgeId'],
          mipmap: [
            badgeData['image1'],
            badgeData['image2'],
            badgeData['image3'],
          ],
          name: base64Encode(badgeData['badgeId'].codeUnits),
          tag: base64Encode(badgeData['badgeId'].codeUnits),
        ),
      );
    }

    response = await http.get(Uri.parse('https://itzalex.github.io/badges2')); // https://cdn.jsdelivr.net/gh/chatsen/resources/assets/data.json'));
    jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    for (var badgeData in jsonResponse['badges']) {
      for (var user in badgeData['users']) {
        badges['$user'] ??= [];
        badges['$user']!.add(
          twitch.Badge(
            title: badgeData['tooltip'],
            description: null,
            id: base64Encode(badgeData['tooltip'].codeUnits),
            mipmap: [
              badgeData['image1'],
              badgeData['image2'],
              badgeData['image3'],
            ],
            name: base64Encode(badgeData['tooltip'].codeUnits),
            tag: base64Encode(badgeData['tooltip'].codeUnits),
          ),
        );
      }
    }

    response = await http.get(Uri.parse('https://itzalex.github.io/badges')); // https://cdn.jsdelivr.net/gh/chatsen/resources/assets/data.json'));
    jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    for (var badgeData in jsonResponse['badges']) {
      for (var user in badgeData['users']) {
        badges['$user'] ??= [];
        badges['$user']!.add(
          twitch.Badge(
            title: badgeData['tooltip'],
            description: null,
            id: badgeData['id'],
            mipmap: [
              badgeData['image1'],
              badgeData['image2'],
              badgeData['image3'],
            ],
            name: base64Encode(badgeData['id'].codeUnits),
            tag: base64Encode(badgeData['id'].codeUnits),
          ),
        );
      }
    }

    emit(badges);
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
