import 'package:chatsen/providers/badge_provider.dart';

import '../api/twitch/twitch.dart';
import '../data/badge.dart';
import '../data/badge_users.dart';
import 'provider.dart';

class TwitchProvider extends Provider with BadgeProvider {
  @override
  String get name => 'Twitch';

  @override
  String? get description => null;

  @override
  Future<List<Badge>> globalBadges() async {
    final twitchBadges = await Twitch.globalBadges();
    return [
      for (final twitchBadgeData in twitchBadges.entries)
        for (final twitchBadgeVersion in twitchBadgeData.value.entries)
          Badge(
            id: '${twitchBadgeData.key}/${twitchBadgeVersion.key}',
            name: twitchBadgeVersion.value.title,
            description: twitchBadgeVersion.value.description,
            mipmap: [
              twitchBadgeVersion.value.imageUrl1x,
              twitchBadgeVersion.value.imageUrl2x,
              twitchBadgeVersion.value.imageUrl4x,
            ],
            provider: this,
          ),
    ];
  }

  @override
  Future<List<Badge>> channelBadges(String uid) async {
    final twitchBadges = await Twitch.channelBadges(uid);
    return [
      for (final twitchBadgeData in twitchBadges.entries)
        for (final twitchBadgeVersion in twitchBadgeData.value.entries)
          Badge(
            id: '${twitchBadgeData.key}/${twitchBadgeVersion.key}',
            name: twitchBadgeVersion.value.title,
            description: twitchBadgeVersion.value.description,
            mipmap: [
              twitchBadgeVersion.value.imageUrl1x,
              twitchBadgeVersion.value.imageUrl2x,
              twitchBadgeVersion.value.imageUrl4x,
            ],
            provider: this,
          ),
    ];
  }

  @override
  Future<List<Badge>> userBadges(String uid) async => [];

  @override
  Future<List<BadgeUsers>> globalUserBadges() async => [];
}
