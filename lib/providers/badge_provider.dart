import 'package:chatsen/data/badge_users.dart';

import 'provider.dart';
import '../data/custom_badge.dart';

// TODO: Migrate BadgeProvider to use a Map instead of a List
mixin BadgeProvider on Provider {
  Future<List<CustomBadge>> globalBadges() async => throw UnimplementedError();
  Future<List<CustomBadge>> channelBadges(String uid) async => throw UnimplementedError();
  Future<List<CustomBadge>> userBadges(String uid) async => throw UnimplementedError();
  Future<List<BadgeUsers>> globalUserBadges() async => throw UnimplementedError();
}
