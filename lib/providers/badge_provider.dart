import 'provider.dart';
import '/data/badge.dart';

// TODO: Migrate BadgeProvider to use a Map instead of a List
mixin BadgeProvider on Provider {
  Future<List<Badge>> globalBadges() async => throw UnimplementedError();
  Future<List<Badge>> channelBadges(String uid) async => throw UnimplementedError();
  Future<List<Badge>> userBadges(String uid) async => throw UnimplementedError();
}
