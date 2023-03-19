import 'package:json_annotation/json_annotation.dart';

part 'chatsen_static_emote.g.dart';

@JsonSerializable()
class ChatsenStaticEmote {
  String id;
  String name;
  String url;
  int modifiers;

  ChatsenStaticEmote({
    required this.id,
    required this.name,
    required this.url,
    required this.modifiers,
  });

  factory ChatsenStaticEmote.fromJson(Map<String, dynamic> json) => _$ChatsenStaticEmoteFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenStaticEmoteToJson(this);
}
