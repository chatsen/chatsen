import '../data/custom_badge.dart';
import '../data/badge_users.dart';
import '/api/frankerfacez/frankerfacez.dart';
import '/data/emote.dart';
import 'badge_provider.dart';
import 'emote_provider.dart';
import 'provider.dart';

class FrankerFaceZProvider extends Provider with EmoteProvider, BadgeProvider {
  @override
  String get name => 'FrankerFaceZ';

  @override
  String? get description => null;

  @override
  Future<List<Emote>> globalEmotes() async {
    final globalSets = await FrankerFaceZ.globalSets();
    return [
      for (final emoteSet in globalSets)
        for (final emote in emoteSet.emoticons)
          Emote(
            id: '${emote.id}',
            name: emote.name,
            mipmap: [
              for (final url in emote.urls.values) 'https:$url',
            ],
            provider: this,
          ),
    ];
  }

  @override
  Future<List<Emote>> channelEmotes(String uid) async {
    final user = await FrankerFaceZ.user(uid);
    return [
      for (final emoteSet in user.sets.values)
        for (final emote in emoteSet.emoticons)
          Emote(
            id: '${emote.id}',
            name: emote.name,
            mipmap: [
              for (final url in emote.urls.values) 'https:$url',
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
    final badges = await FrankerFaceZ.badges();
    return [
      for (final badge in badges.badges)
        BadgeUsers(
          badge: CustomBadge(
            id: '${badge.id}',
            name: badge.title,
            mipmap: badge.urls.values.map((e) => 'http:$e').toList(),
            provider: this,
          ),
          users: badges.users['${badge.id}']?.map((e) => '$e').toList() ?? [],
        ),
    ];
  }

  @override
  String? emoteUrl(String id) => 'https://www.frankerfacez.com/emoticon/$id';
}
