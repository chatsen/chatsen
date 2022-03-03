import 'package:json_annotation/json_annotation.dart';

import 'frankerfacez_emote.dart';

part 'frankerfacez_set.g.dart';

@JsonSerializable()
class FrankerFaceZSet {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: '_type')
  int type;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'emoticons')
  List<FrankerFaceZEmote> emoticons;

  FrankerFaceZSet({
    required this.id,
    required this.type,
    required this.title,
    required this.emoticons,
  });

  factory FrankerFaceZSet.fromJson(Map<String, dynamic> json) => _$FrankerFaceZSetFromJson(json);

  Map<String, dynamic> toJson() => _$FrankerFaceZSetToJson(this);
}
