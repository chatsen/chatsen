import 'emote_provider.dart';
import 'provider.dart';
import '/data/emote.dart';
import '/api/seventv/seventv.dart';

class SevenTVProvider extends Provider with EmoteProvider {
  @override
  String get name => '7TV';

  @override
  String? get description => null;

  @override
  Future<List<Emote>> globalEmotes() async {
    final globalEmotes = await SevenTV.globalEmotes();
    return [
      for (final emote in globalEmotes)
        Emote(
          id: emote.id,
          name: emote.name,
          mipmap: [
            for (final urlArray in emote.urls) urlArray.last,
          ],
          provider: this,
        ),
    ];
  }

  @override
  Future<List<Emote>> channelEmotes(String uid) async {
    final channelEmotes = await SevenTV.channelEmotes(uid);
    return [
      for (final emote in channelEmotes)
        Emote(
          id: emote.id,
          name: emote.name,
          mipmap: [
            for (final urlArray in emote.urls) urlArray.last,
          ],
          provider: this,
        ),
    ];
  }
}
