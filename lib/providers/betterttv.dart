import '/api/betterttv/betterttv.dart';
import '/data/emote.dart';
import 'emote_provider.dart';
import 'provider.dart';

class BetterTTVProvider extends Provider with EmoteProvider {
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
}
