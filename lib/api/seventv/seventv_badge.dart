import 'package:json_annotation/json_annotation.dart';

part 'seventv_badge.g.dart';

@JsonSerializable()
class SevenTVBadge {
  String id;
  String name;
  String tooltip;
  List<List<String>> urls;
  List<String> users;

  SevenTVBadge({
    required this.id,
    required this.name,
    required this.tooltip,
    required this.urls,
    required this.users,
  });

  factory SevenTVBadge.fromJson(Map<String, dynamic> json) => _$SevenTVBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$SevenTVBadgeToJson(this);
}
