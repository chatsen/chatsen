import 'package:chatsen/api/chatsen/chatsen.dart';

import '../data/custom_badge.dart';
import '../data/badge_users.dart';
import 'badge_provider.dart';
import 'provider.dart';

class ChatsenProvider extends Provider with BadgeProvider {
  @override
  String get name => 'Chatsen';

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
    final badges = await Chatsen.badges();
    return [
      for (final badge in badges)
        BadgeUsers(
          badge: CustomBadge(
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
