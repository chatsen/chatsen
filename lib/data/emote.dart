import '../providers/provider.dart';

// TODO: Have code field for emotes/emojis
class Emote {
  String id;
  String name;
  String? code;
  String? description;
  List<String> mipmap;
  int flags;
  Provider provider;

  Emote({
    required this.id,
    required this.name,
    this.code,
    this.description,
    required this.mipmap,
    this.flags = 0,
    required this.provider,
  });
}
