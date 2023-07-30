import '../providers/provider.dart';

class EmoteFlags {
  static int overlay = (1 << 0);
}

class Emote {
  String id;
  String name;
  String? code;
  String? description;
  List<String> mipmap;
  int flags;
  Provider provider;
  String? category;

  Emote({
    required this.id,
    required this.name,
    this.code,
    this.description,
    required this.mipmap,
    this.flags = 0,
    required this.provider,
    this.category,
  });
}
