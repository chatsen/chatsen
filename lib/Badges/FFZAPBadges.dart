import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class FFZAPBadges extends Cubit<Map<String, List<twitch.Badge>>> {
  FFZAPBadges() : super({}) {
    refresh();
  }

  // https://github.com/FrankerFaceZ/Add-Ons/blob/master/src/ffzap-core/index.js#L11
  static Map<String, String> helpers = {
    // Lordmau5
    '26964566': 'FFZ:AP Developer',
    // Jugachi
    '11819690': 'FFZ:AP Helper',
    // mieDax
    '36442149': 'FFZ:AP Helper',
    // Quanto
    '29519423': 'FFZ:AP Helper',
    // trihex
    '22025290': 'FFZ:AP Helper',
    // Wolsk
    '4867723': 'FFZ:AP Helper',
  };

  void refresh() async {
    var response = await http.get(Uri.parse('https://api.ffzap.com/v1/supporters'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    var users = <String, List<twitch.Badge>>{
      for (var badgeData in jsonResponse)
        badgeData['id'].toString(): [
          twitch.Badge(
            title: helpers[badgeData['id'].toString()] ?? 'FFZ:AP Supporter',
            description: null,
            id: badgeData['id'].toString(),
            mipmap: [
              'https://api.ffzap.com/v1/user/badge/${badgeData['id']}/1',
              'https://api.ffzap.com/v1/user/badge/${badgeData['id']}/2',
              'https://api.ffzap.com/v1/user/badge/${badgeData['id']}/3',
            ],
            name: badgeData['id'].toString(),
            tag: badgeData['id'].toString(),
            // color: badgeData['badge_color']?.substring(1),
          ),
        ],
    };

    emit(users);
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
