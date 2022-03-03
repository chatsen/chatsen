import 'package:json_annotation/json_annotation.dart';

part 'frankerfacez_room.g.dart';

@JsonSerializable()
class FrankerFaceZRoom {
  @JsonKey(name: '_id')
  int id;

  @JsonKey(name: 'twitch_id')
  int? twitchId;

  @JsonKey(name: 'youtube_id')
  dynamic youtubeId;

  @JsonKey(name: 'set')
  int setId;

  @JsonKey(name: 'vip_badge')
  Map<String, String>? vipBadge;

  @JsonKey(name: 'mod_urls')
  Map<String, String>? modUrls;

  FrankerFaceZRoom({
    required this.id,
    this.twitchId,
    this.youtubeId,
    required this.setId,
    this.vipBadge,
    this.modUrls,
  });

  factory FrankerFaceZRoom.fromJson(Map<String, dynamic> json) => _$FrankerFaceZRoomFromJson(json);

  Map<String, dynamic> toJson() => _$FrankerFaceZRoomToJson(this);
}
