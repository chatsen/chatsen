import 'provider.dart';
import '/data/emote.dart';

mixin EmoteProvider on Provider {
  Future<List<Emote>> globalEmotes() async => throw UnimplementedError();
  Future<List<Emote>> channelEmotes(String uid) async => throw UnimplementedError();
}
