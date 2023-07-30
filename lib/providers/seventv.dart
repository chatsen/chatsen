import '../data/custom_badge.dart';
import '../data/badge_users.dart';
import 'badge_provider.dart';
import 'emote_provider.dart';
import 'provider.dart';
import '/data/emote.dart';
import '/api/seventv/seventv.dart';

class SevenTVProvider extends Provider with EmoteProvider, BadgeProvider {
  @override
  String get name => '7TV';

  @override
  String? get description => null;

  @override
  Future<List<Emote>> globalEmotes() async {
    final globalEmotes = await SevenTV.globalEmotes();
    return [
      for (final emote in globalEmotes.where((emote) => emote.data.host.files.isNotEmpty))
        Emote(
          id: emote.id,
          name: emote.name,
          mipmap: [
            for (final urlArray in emote.data.host.files.where((element) => element.format != 'AVIF')) 'https:${emote.data.host.url}/${urlArray.name}',
          ],
          provider: this,
          flags: ((emote.data.flags & (1 << 8)) == (1 << 8)) ? EmoteFlags.overlay : 0,
        ),
    ];
  }

  @override
  Future<List<Emote>> channelEmotes(String uid) async {
    final channelEmotes = await SevenTV.channelEmotes(uid);
    return [
      for (final emote in channelEmotes.where((emote) => emote.data.host.files.isNotEmpty))
        Emote(
          id: emote.id,
          name: emote.name,
          mipmap: [
            for (final urlArray in emote.data.host.files.where((element) => element.format != 'AVIF')) 'https:${emote.data.host.url}/${urlArray.name}',
          ],
          provider: this,
          flags: ((emote.data.flags & (1 << 8)) == (1 << 8)) ? EmoteFlags.overlay : 0,
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
    final cosmetics = await SevenTV.cosmetics();
    return [
      for (final badge in cosmetics.badges)
        BadgeUsers(
          badge: CustomBadge(
            id: badge.id,
            name: badge.tooltip,
            mipmap: [
              for (final url in badge.urls) url.last,
            ],
            provider: this,
          ),
          users: badge.users,
        ),
    ];
  }

  @override
  String? emoteUrl(String id) => 'https://7tv.app/emotes/$id';
}
