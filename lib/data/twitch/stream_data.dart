import 'package:json_annotation/json_annotation.dart';

part 'stream_data.g.dart';

@JsonSerializable()
class StreamData {
  String id;

  @JsonKey(name: 'user_id')
  String userId;

  @JsonKey(name: 'user_login')
  String userLogin;

  @JsonKey(name: 'user_name')
  String userName;

  @JsonKey(name: 'game_id')
  String gameId;

  @JsonKey(name: 'game_name')
  String gameName;

  String type;

  String title;

  @JsonKey(name: 'viewer_count')
  int viewerCount;

  @JsonKey(name: 'started_at')
  DateTime startedAt;

  String language;

  @JsonKey(name: 'thumbnail_url')
  String thumbnailUrl;

  @JsonKey(name: 'tag_ids')
  List<String> tagIds;

  List<String>? tags;

  @JsonKey(name: 'is_mature')
  bool isMature;

  StreamData({
    required this.id,
    required this.userId,
    required this.userLogin,
    required this.userName,
    required this.gameId,
    required this.gameName,
    required this.type,
    required this.title,
    required this.viewerCount,
    required this.startedAt,
    required this.language,
    required this.thumbnailUrl,
    required this.tagIds,
    this.tags,
    required this.isMature,
  });

  factory StreamData.fromJson(Map<String, dynamic> json) => _$StreamDataFromJson(json);

  Map<String, dynamic> toJson() => _$StreamDataToJson(this);
}
