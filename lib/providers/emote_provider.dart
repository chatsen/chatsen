import 'provider.dart';
import '/data/emote.dart';

// TODO: Migrate EmoteProvider to use a Map instead of a List
mixin EmoteProvider on Provider {
  Future<List<Emote>> globalEmotes() async => throw UnimplementedError();
  Future<List<Emote>> channelEmotes(String uid) async => throw UnimplementedError();
}
