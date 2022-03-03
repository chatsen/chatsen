import 'package:json_annotation/json_annotation.dart';

part 'betterttv_emote.g.dart';

@JsonSerializable()
class BetterTTVEmote {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'imageType')
  String imageType;

  @JsonKey(name: 'userId')
  String? userId;

  BetterTTVEmote({
    required this.id,
    required this.code,
    required this.imageType,
    this.userId,
  });

  factory BetterTTVEmote.fromJson(Map<String, dynamic> json) => _$BetterTTVEmoteFromJson(json);

  Map<String, dynamic> toJson() => _$BetterTTVEmoteToJson(this);
}
