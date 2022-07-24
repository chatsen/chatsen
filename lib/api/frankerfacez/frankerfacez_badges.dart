import 'package:json_annotation/json_annotation.dart';

import 'frankerfacez_badge.dart';

part 'frankerfacez_badges.g.dart';

@JsonSerializable()
class FrankerFaceZBadges {
  List<FrankerFaceZBadge> badges;
  Map<String, List<int>> users;

  FrankerFaceZBadges({
    required this.badges,
    required this.users,
  });

  factory FrankerFaceZBadges.fromJson(Map<String, dynamic> json) => _$FrankerFaceZBadgesFromJson(json);
  Map<String, dynamic> toJson() => _$FrankerFaceZBadgesToJson(this);
}
