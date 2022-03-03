import 'dart:convert';
import 'package:http/http.dart' as http;

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';

class Twitch {
  static Future<TokenData> validateToken(String token) async {
    var response = await http.get(
      Uri.parse('https://id.twitch.tv/oauth2/validate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return TokenData(
      clientId: responseJson['client_id'],
      login: responseJson['login'],
      scopes: List<String>.from(responseJson['scopes'] ?? []),
      userId: responseJson['user_id'],
      expiresAt: responseJson['expires_in'] == 0
          ? null
          : DateTime.now().add(
              Duration(seconds: responseJson['expires_in']),
            ),
      accessToken: token,
    );
  }

  static Future<UserData> userData(TokenData tokenData) async {
    var response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return UserData(
      displayName: responseJson['data'][0]['display_name'],
      avatarUrl: responseJson['data'][0]['profile_image_url'],
      offlineUrl: responseJson['data'][0]['offline_image_url'],
    );
  }
}
