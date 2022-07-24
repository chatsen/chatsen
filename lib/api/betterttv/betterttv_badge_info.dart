import 'package:json_annotation/json_annotation.dart';

part 'betterttv_badge_info.g.dart';

@JsonSerializable()
class BetterTTVBadgeInfo {
  String description;
  String svg;

  BetterTTVBadgeInfo({
    required this.description,
    required this.svg,
  });

  factory BetterTTVBadgeInfo.fromJson(Map<String, dynamic> json) => _$BetterTTVBadgeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BetterTTVBadgeInfoToJson(this);
}
