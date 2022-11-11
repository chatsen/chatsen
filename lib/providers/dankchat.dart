import 'dart:convert';

import 'package:chatsen/providers/badge_provider.dart';
import 'package:chatsen/providers/provider.dart';

import '../api/dankchat/dankchat.dart';
import '../data/custom_badge.dart';
import '../data/badge_users.dart';

class DankChatProvider extends Provider with BadgeProvider {
  @override
  String get name => 'DankChat';

  @override
  String? get description => null;

  @override
  Future<List<CustomBadge>> globalBadges() async => [];

  @override
  Future<List<CustomBadge>> channelBadges(String uid) async => [];

  @override
  Future<List<CustomBadge>> userBadges(String uid) async => [];

  @override
  Future<List<BadgeUsers>> globalUserBadges() async {
    final badges = await DankChat.badges();
    return [
      for (final badge in badges)
        BadgeUsers(
          badge: CustomBadge(
            id: base64Encode(badge.url.codeUnits),
            name: badge.type,
            mipmap: [
              badge.url,
            ],
            provider: this,
          ),
          users: badge.users,
        ),
    ];
  }
}
