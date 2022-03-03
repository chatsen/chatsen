import 'package:json_annotation/json_annotation.dart';

part 'seventv_emote.g.dart';

@JsonSerializable()
class SevenTVEmote {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'visibility')
  int visibility;

  @JsonKey(name: 'mime')
  String mime;

  @JsonKey(name: 'urls')
  List<List<String>> urls;

  SevenTVEmote({
    required this.id,
    required this.name,
    required this.visibility,
    required this.mime,
    required this.urls,
  });

  factory SevenTVEmote.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteToJson(this);
}
