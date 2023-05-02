import 'package:json_annotation/json_annotation.dart';

part 'twitch_ban_response_data.g.dart';

@JsonSerializable()
class TwitchBanResponseData {
  @JsonKey(name: 'broadcaster_id')
  final String broadcasterId;

  @JsonKey(name: 'moderator_id')
  final String moderatorId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'end_time')
  final String? endTime;

  TwitchBanResponseData({
    required this.broadcasterId,
    required this.moderatorId,
    required this.userId,
    required this.createdAt,
    this.endTime,
  });

  factory TwitchBanResponseData.fromJson(Map<String, dynamic> json) => _$TwitchBanResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TwitchBanResponseDataToJson(this);
}
