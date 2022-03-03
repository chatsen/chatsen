import 'package:json_annotation/json_annotation.dart';

import 'betterttv_emote.dart';

part 'betterttv_user.g.dart';

@JsonSerializable()
class BetterTTVUser {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'channelEmotes')
  List<BetterTTVEmote> channelEmotes;

  @JsonKey(name: 'sharedEmotes')
  List<BetterTTVEmote> sharedEmotes;

  BetterTTVUser({
    required this.id,
    required this.avatar,
    required this.channelEmotes,
    required this.sharedEmotes,
  });

  factory BetterTTVUser.fromJson(Map<String, dynamic> json) => _$BetterTTVUserFromJson(json);

  Map<String, dynamic> toJson() => _$BetterTTVUserToJson(this);
}
