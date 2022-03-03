import 'package:json_annotation/json_annotation.dart';

import '/api/frankerfacez/frankerfacez_room.dart';
import '/api/frankerfacez/frankerfacez_set.dart';

part 'frankerfacez_user.g.dart';

@JsonSerializable()
class FrankerFaceZUser {
  @JsonKey(name: 'room')
  FrankerFaceZRoom room;

  @JsonKey(name: 'sets')
  Map<String, FrankerFaceZSet> sets;

  FrankerFaceZUser({
    required this.room,
    required this.sets,
  });

  factory FrankerFaceZUser.fromJson(Map<String, dynamic> json) => _$FrankerFaceZUserFromJson(json);

  Map<String, dynamic> toJson() => _$FrankerFaceZUserToJson(this);
}
