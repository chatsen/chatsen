import 'package:json_annotation/json_annotation.dart';

part 'search_data.g.dart';

@JsonSerializable()
class SearchData {
  @JsonKey(name: 'broadcaster_language')
  String broadcasterLanguage;

  @JsonKey(name: 'broadcaster_login')
  String broadcasterLogin;

  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'game_id')
  String gameId;

  @JsonKey(name: 'game_name')
  String gameName;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'is_live')
  bool isLive;

  @JsonKey(name: 'tag_ids')
  List<String> tagIds;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'thumbnail_url')
  String thumbnailUrl;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'started_at')
  String startedAt;

  SearchData({
    required this.broadcasterLanguage,
    required this.broadcasterLogin,
    required this.displayName,
    required this.gameId,
    required this.gameName,
    required this.id,
    required this.isLive,
    required this.tagIds,
    required this.tags,
    required this.thumbnailUrl,
    required this.title,
    required this.startedAt,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => _$SearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}
