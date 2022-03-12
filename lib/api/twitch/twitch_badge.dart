import 'package:json_annotation/json_annotation.dart';

part 'twitch_badge.g.dart';

@JsonSerializable()
class TwitchBadge {
  @JsonKey(name: 'image_url_1x')
  String imageUrl1x;

  @JsonKey(name: 'image_url_2x')
  String imageUrl2x;

  @JsonKey(name: 'image_url_4x')
  String imageUrl4x;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'title')
  String title;

  // @JsonKey(name: 'version', ignore: true)
  // String? version;

  TwitchBadge({
    required this.imageUrl1x,
    required this.imageUrl2x,
    required this.imageUrl4x,
    required this.description,
    required this.title,
    // this.version,
  });

  factory TwitchBadge.fromJson(Map<String, dynamic> json) => _$TwitchBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$TwitchBadgeToJson(this);
}
