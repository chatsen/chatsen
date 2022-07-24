import 'package:json_annotation/json_annotation.dart';

import 'betterttv_badge_info.dart';

part 'betterttv_badge.g.dart';

@JsonSerializable()
class BetterTTVBadge {
  String id;
  String name;
  String displayName;
  String providerId;
  BetterTTVBadgeInfo badge;

  BetterTTVBadge({
    required this.id,
    required this.name,
    required this.displayName,
    required this.providerId,
    required this.badge,
  });

  factory BetterTTVBadge.fromJson(Map<String, dynamic> json) => _$BetterTTVBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BetterTTVBadgeToJson(this);
}
