import 'package:json_annotation/json_annotation.dart';

part 'chatsen_badge.g.dart';

@JsonSerializable()
class ChatsenBadge {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'mipmap')
  List<String> mipmap;

  @JsonKey(name: 'users')
  List<String> users;

  ChatsenBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.mipmap,
    required this.users,
  });

  factory ChatsenBadge.fromJson(Map<String, dynamic> json) => _$ChatsenBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsenBadgeToJson(this);
}
