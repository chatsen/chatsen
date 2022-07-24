import 'package:json_annotation/json_annotation.dart';

part 'frankerfacez_badge.g.dart';

@JsonSerializable()
class FrankerFaceZBadge {
  int id;
  String name;
  String title;
  int slot;
  String? replaces;
  String color;
  String image;
  Map<String, String> urls;
  String? css;

  FrankerFaceZBadge({
    required this.id,
    required this.name,
    required this.title,
    required this.slot,
    this.replaces,
    required this.color,
    required this.image,
    required this.urls,
    this.css,
  });

  factory FrankerFaceZBadge.fromJson(Map<String, dynamic> json) => _$FrankerFaceZBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$FrankerFaceZBadgeToJson(this);
}
