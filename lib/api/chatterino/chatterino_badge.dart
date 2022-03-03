import 'package:json_annotation/json_annotation.dart';

part 'chatterino_badge.g.dart';

@JsonSerializable()
class ChatterinoBadge {
  @JsonKey(name: 'image1')
  String image1;

  @JsonKey(name: 'image2')
  String image2;

  @JsonKey(name: 'image3')
  String image3;

  @JsonKey(name: 'tooltip')
  String tooltip;

  @JsonKey(name: 'badges')
  List<String> badges;

  ChatterinoBadge({
    required this.image1,
    required this.image2,
    required this.image3,
    required this.tooltip,
    required this.badges,
  });

  factory ChatterinoBadge.fromJson(Map<String, dynamic> json) => _$ChatterinoBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$ChatterinoBadgeToJson(this);
}
