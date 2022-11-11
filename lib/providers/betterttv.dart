import 'package:chatsen/providers/badge_provider.dart';

import '../data/custom_badge.dart';
import '../data/badge_users.dart';
import '/api/betterttv/betterttv.dart';
import '/data/emote.dart';
import 'emote_provider.dart';
import 'provider.dart';

class BetterTTVProvider extends Provider with EmoteProvider, BadgeProvider {
  @override
  String get name => 'BetterTTV';

  @override
  String? get description => null;

  @override
  Future<List<Emote>> globalEmotes() async {
    final globalEmotes = await BetterTTV.globalEmotes();
    return [
      for (final emote in globalEmotes)
        Emote(
          id: emote.id,
          name: emote.code,
          mipmap: [
            'https://cdn.betterttv.net/emote/${emote.id}/1x',
            'https://cdn.betterttv.net/emote/${emote.id}/2x',
            'https://cdn.betterttv.net/emote/${emote.id}/3x',
          ],
          provider: this,
        ),
    ];
  }

  @override
  Future<List<Emote>> channelEmotes(String uid) async {
    final user = await BetterTTV.user(uid);
    return [
      for (final emote in [...user.channelEmotes, ...user.sharedEmotes])
        Emote(
          id: emote.id,
          name: emote.code,
          mipmap: [
            'https://cdn.betterttv.net/emote/${emote.id}/1x',
            'https://cdn.betterttv.net/emote/${emote.id}/2x',
            'https://cdn.betterttv.net/emote/${emote.id}/3x',
          ],
          provider: this,
        ),
    ];
  }

  @override
  Future<List<CustomBadge>> globalBadges() async => [];

  @override
  Future<List<CustomBadge>> channelBadges(String uid) async => [];

  @override
  Future<List<CustomBadge>> userBadges(String uid) async => [];

  @override
  Future<List<BadgeUsers>> globalUserBadges() async {
    final badges = await BetterTTV.badges();
    return [
      for (final badge in badges)
        BadgeUsers(
          badge: CustomBadge(
            id: badge.id,
            name: badge.badge.description,
            mipmap: [
              badge.badge.svg,
            ],
            provider: this,
          ),
          users: [
            badge.providerId,
          ],
        ),
    ];
  }

  @override
  String? emoteUrl(String id) => 'https://betterttv.com/emotes/$id';
}
