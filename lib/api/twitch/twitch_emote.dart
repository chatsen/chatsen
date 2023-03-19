import 'package:json_annotation/json_annotation.dart';

part 'twitch_emote.g.dart';

@JsonSerializable()
class TwitchEmote {
  final String id;
  final String name;
  final Map<String, String> images;

  @JsonKey(name: 'emote_type')
  final String emoteType;

  @JsonKey(name: 'emote_set_id')
  final String emoteSetId;

  @JsonKey(name: 'owner_id')
  final String ownerId;

  final List<String> format;
  final List<String> scale;

  @JsonKey(name: 'theme_mode')
  final List<String> themeMode;

  TwitchEmote({
    required this.id,
    required this.name,
    required this.images,
    required this.emoteType,
    required this.emoteSetId,
    required this.ownerId,
    required this.format,
    required this.scale,
    required this.themeMode,
  });

  factory TwitchEmote.fromJson(Map<String, dynamic> json) => _$TwitchEmoteFromJson(json);
  Map<String, dynamic> toJson() => _$TwitchEmoteToJson(this);
}
