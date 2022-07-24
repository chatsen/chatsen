import 'package:chatsen/api/chatsen/chatsen.dart';

import '../data/badge.dart';
import '../data/badge_users.dart';
import 'badge_provider.dart';
import 'provider.dart';

class ChatsenProvider extends Provider with BadgeProvider {
  @override
  String get name => 'Chatsen';

  @override
  String? get description => null;

  @override
  Future<List<Badge>> globalBadges() async => [];

  @override
  Future<List<Badge>> channelBadges(String uid) async => [];

  @override
  Future<List<Badge>> userBadges(String uid) async => [];

  @override
  Future<List<BadgeUsers>> globalUserBadges() async {
    final badges = await Chatsen.badges();
    return [
      for (final badge in badges)
        BadgeUsers(
          badge: Badge(
            id: badge.id,
            name: badge.name,
            mipmap: badge.mipmap,
            provider: this,
          ),
          users: badge.users,
        ),
    ];
  }
}
