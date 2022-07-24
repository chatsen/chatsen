import 'dart:convert';

import 'package:chatsen/api/frankerfacez/frankerfacez_badges.dart';
import 'package:http/http.dart' as http;

import '/api/frankerfacez/frankerfacez_set.dart';
import 'frankerfacez_user.dart';

class FrankerFaceZ {
  static Future<FrankerFaceZUser> user(String uid) async {
    final response = await http.get(Uri.parse('https://api.frankerfacez.com/v1/room/id/$uid'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return FrankerFaceZUser.fromJson(responseJson);
  }

  static Future<List<FrankerFaceZSet>> globalSets() async {
    final response = await http.get(Uri.parse('https://api.frankerfacez.com/v1/set/global'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final setData in responseJson['sets'].values) FrankerFaceZSet.fromJson(setData),
    ];
  }

  static Future<FrankerFaceZBadges> badges() async {
    final response = await http.get(Uri.parse('https://api.frankerfacez.com/v1/badges/ids'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return FrankerFaceZBadges.fromJson(responseJson);
  }
}
