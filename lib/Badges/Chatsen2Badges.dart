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
      if (responseJson is! List) return;

      final users = <String, List<twitch.Badge>>{};
      for (final raw in responseJson) {
        if (raw is! Map) continue;

        final rawUsers = raw['users'];
        final rawMipmap = raw['mipmap'];
        if (rawUsers is! List || rawMipmap is! List) continue;

        final mipmap = rawMipmap.map((x) => x?.toString()).whereType<String>().where((x) => x.isNotEmpty).toList();
        if (mipmap.isEmpty) continue;

        final badge = twitch.Badge(
          title: raw['name']?.toString(),
          id: raw['id']?.toString(),
          description: raw['description']?.toString(),
          name: raw['name']?.toString(),
          tag: raw['name']?.toString(),
          mipmap: mipmap,
        );

        for (final userIdRaw in rawUsers) {
          final userId = userIdRaw?.toString();
          if (userId == null || userId.isEmpty) continue;
          users.putIfAbsent(userId, () => <twitch.Badge>[]);
          users[userId]!.add(badge);
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
