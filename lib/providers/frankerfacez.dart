import '/api/frankerfacez/frankerfacez.dart';
import '/data/emote.dart';
import 'emote_provider.dart';
import 'provider.dart';

class FrankerFaceZProvider extends Provider with EmoteProvider {
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
}
