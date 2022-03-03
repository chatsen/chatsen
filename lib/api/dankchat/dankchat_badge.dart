import 'package:json_annotation/json_annotation.dart';

part 'dankchat_badge.g.dart';

@JsonSerializable()
class DankChatBadge {
  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'users')
  List<String> users;

  DankChatBadge({
    required this.type,
    required this.url,
    required this.users,
  });

  factory DankChatBadge.fromJson(Map<String, dynamic> json) => _$DankChatBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$DankChatBadgeToJson(this);
}
