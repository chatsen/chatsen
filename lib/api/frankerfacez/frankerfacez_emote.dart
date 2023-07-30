import 'package:json_annotation/json_annotation.dart';

part 'frankerfacez_emote.g.dart';

@JsonSerializable()
class FrankerFaceZEmote {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'public')
  bool public;

  @JsonKey(name: 'hidden')
  bool hidden;

  @JsonKey(name: 'modifier')
  bool modifier;

  @JsonKey(name: 'urls')
  Map<String, String> urls;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'usage_count')
  int usageCount;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'last_updated')
  DateTime? lastUpdated;

  FrankerFaceZEmote({
    required this.id,
    required this.name,
    required this.height,
    required this.width,
    required this.public,
    required this.hidden,
    required this.modifier,
    required this.urls,
    required this.status,
    required this.usageCount,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory FrankerFaceZEmote.fromJson(Map<String, dynamic> json) => _$FrankerFaceZEmoteFromJson(json);

  Map<String, dynamic> toJson() => _$FrankerFaceZEmoteToJson(this);
}
