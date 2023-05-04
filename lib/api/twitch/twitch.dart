import 'dart:convert';
import 'package:chatsen/api/twitch/twitch_badge.dart';
import 'package:chatsen/api/twitch/twitch_emote.dart';
import 'package:http/http.dart' as http;

import '/data/twitch/search_data.dart';
import '/data/twitch/stream_data.dart';
import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import 'twitch_ban_response_data.dart';

class Twitch {
  static Future<List<String>> blockedUsers(TokenData tokenData) async {
    try {
      final result = <String>[];
      const pageSize = 100;
      String? cursor;

      do {
        final response = await http.get(
          Uri.parse('https://api.twitch.tv/helix/users/blocks?broadcaster_id=${tokenData.userId}&first=$pageSize${cursor != null ? '&after=$cursor' : ''}'),
          headers: {
            'Authorization': 'Bearer ${tokenData.accessToken}',
            'Client-Id': '${tokenData.clientId}',
          },
        );
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        final data = List<dynamic>.from(responseJson['data']);
        result.addAll(data.map((e) => e['user_id']));
        cursor = responseJson['pagination']?['cursor'];
        // if (data.length < pageSize) break;
      } while (cursor != null);

      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<TokenData> validateToken(String token) async {
    final response = await http.get(
      Uri.parse('https://id.twitch.tv/oauth2/validate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
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
    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return UserData(
      displayName: responseJson['data'][0]['display_name'],
      avatarUrl: responseJson['data'][0]['profile_image_url'],
      offlineUrl: responseJson['data'][0]['offline_image_url'],
    );
  }

  static Future<Map<String, Map<String, TwitchBadge>>> globalBadges() async {
    final response = await http.get(Uri.parse('https://badges.twitch.tv/v1/badges/global/display'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return {
      for (final badgeData in responseJson['badge_sets'].entries)
        badgeData.key: {
          for (final badgeVersion in badgeData.value['versions'].entries)
            badgeVersion.key: TwitchBadge.fromJson(
              badgeVersion.value,
            ),
        },
    };
  }

  static Future<Map<String, Map<String, TwitchBadge>>> channelBadges(String uid) async {
    final response = await http.get(Uri.parse('https://badges.twitch.tv/v1/badges/channels/$uid/display')); // ?language=en
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return {
      for (final badgeData in responseJson['badge_sets'].entries)
        badgeData.key: {
          for (final badgeVersion in badgeData.value['versions'].entries)
            badgeVersion.key: TwitchBadge.fromJson(
              badgeVersion.value,
            ),
        },
    };
  }

  static Future<List<StreamData>> streams(
    TokenData tokenData, {
    List<String>? userLogins,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://api.twitch.tv/helix/streams?first=100${userLogins != null ? '&${userLogins.map((e) => 'user_login=$e').join('&')}' : ''}',
      ),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final data in responseJson['data']) StreamData.fromJson(data),
    ];
  }

  static Future<List<SearchData>> channelSearch(TokenData tokenData, String query) async {
    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/search/channels?query=$query'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    return [
      for (final data in responseJson['data']) SearchData.fromJson(data),
    ];
  }

  static Future<List<TwitchEmote>> emoteSets(TokenData tokenData, List<String> emoteSetIds) async {
    const takeCount = 25;
    final emotes = <TwitchEmote>[];
    while (emoteSetIds.isNotEmpty) {
      final emoteSetsPack = emoteSetIds.take(takeCount).toList();
      final response = await http.get(
        Uri.parse('https://api.twitch.tv/helix/chat/emotes/set?${emoteSetsPack.map((x) => 'emote_set_id=$x').join('&')}'),
        headers: {
          'Authorization': 'Bearer ${tokenData.accessToken}',
          'Client-Id': '${tokenData.clientId}',
        },
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      emotes.addAll([
        for (final data in responseJson['data']) TwitchEmote.fromJson(data),
      ]);
      emoteSetIds.removeRange(0, emoteSetsPack.length);
    }
    return emotes;
  }

  static Future<TwitchBanResponseData> ban(
    TokenData tokenData, {
    required String broadcasterId,
    required String moderatorId,
    required String userId,
    int? duration,
    String? reason,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.twitch.tv/helix/moderation/bans?broadcaster_id=$broadcasterId&moderator_id=$moderatorId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'data': {
          'user_id': userId,
          if (duration != null) 'duration': duration,
          if (reason != null) 'reason': reason,
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      return TwitchBanResponseData.fromJson(responseJson['data'][0]);
    } else {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> unban(
    TokenData tokenData, {
    required String broadcasterId,
    required String moderatorId,
    required String userId,
  }) async {
    final response = await http.delete(
      Uri.parse('https://api.twitch.tv/helix/moderation/bans?broadcaster_id=$broadcasterId&moderator_id=$moderatorId&user_id=$userId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> deleteChatMessage(
    TokenData tokenData, {
    required String broadcasterId,
    required String moderatorId,
    String? messageId,
  }) async {
    final response = await http.delete(
      Uri.parse('https://api.twitch.tv/helix/moderation/chat?broadcaster_id=$broadcasterId&moderator_id=$moderatorId${messageId != null ? '&message_id=$messageId' : ''}'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> addModerator(
    TokenData tokenData, {
    required String broadcasterId,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.twitch.tv/helix/moderation/moderators?broadcaster_id=$broadcasterId&user_id=$userId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> removeModerator(
    TokenData tokenData, {
    required String broadcasterId,
    required String userId,
  }) async {
    final response = await http.delete(
      Uri.parse('https://api.twitch.tv/helix/moderation/moderators?broadcaster_id=$broadcasterId&user_id=$userId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> changeChatColor(
    TokenData tokenData, {
    required String userId,
    required String color,
  }) async {
    final response = await http.put(
      Uri.parse('https://api.twitch.tv/helix/chat/color?user_id=$userId&color=${Uri.encodeComponent(color)}'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
      },
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<void> sendAnnouncement(
    TokenData tokenData, {
    required String broadcasterId,
    required String moderatorId,
    required String message,
    required String color,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.twitch.tv/helix/chat/announcements?broadcaster_id=$broadcasterId&moderator_id=$moderatorId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'message': message,
        'color': color,
      }),
    );

    if (response.statusCode != 204) {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }

  static Future<Map<String, dynamic>> updateChatSettings(
    TokenData tokenData, {
    required String broadcasterId,
    required String moderatorId,
    bool? emoteMode,
    bool? followerMode,
    int? followerModeDuration,
    bool? nonModeratorChatDelay,
    int? nonModeratorChatDelayDuration,
    bool? slowMode,
    int? slowModeWaitTime,
    bool? subscriberMode,
    bool? uniqueChatMode,
  }) async {
    final settings = {
      if (emoteMode != null) 'emote_mode': emoteMode,
      if (followerMode != null) 'follower_mode': followerMode,
      if (followerModeDuration != null) 'follower_mode_duration': followerModeDuration,
      if (nonModeratorChatDelay != null) 'non_moderator_chat_delay': nonModeratorChatDelay,
      if (nonModeratorChatDelayDuration != null) 'non_moderator_chat_delay_duration': nonModeratorChatDelayDuration,
      if (slowMode != null) 'slow_mode': slowMode,
      if (slowModeWaitTime != null) 'slow_mode_wait_time': slowModeWaitTime,
      if (subscriberMode != null) 'subscriber_mode': subscriberMode,
      if (uniqueChatMode != null) 'unique_chat_mode': uniqueChatMode,
    };

    final response = await http.patch(
      Uri.parse('https://api.twitch.tv/helix/chat/settings?broadcaster_id=$broadcasterId&moderator_id=$moderatorId'),
      headers: {
        'Authorization': 'Bearer ${tokenData.accessToken}',
        'Client-Id': '${tokenData.clientId}',
        'Content-Type': 'application/json',
      },
      body: json.encode(settings),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      return responseJson['data'][0];
    } else {
      final errorJson = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorJson['error']}: ${errorJson['message']}');
    }
  }
}
