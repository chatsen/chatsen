import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class Chatsen2Badges extends Cubit<Map<String, List<twitch.Badge>>> {
  Chatsen2Badges() : super({}) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      final response = await http.get(Uri.parse('https://api.chatsen.app/account/badges'));
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      emit({
        for (final emoteData in responseJson)
          for (final user in emoteData['users'])
            user: [
              twitch.Badge(
                title: emoteData['name'],
                id: emoteData['id'],
                description: emoteData['description'],
                name: emoteData['name'],
                tag: emoteData['name'],
                mipmap: List<String>.from(emoteData['mipmap']),
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
