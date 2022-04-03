import 'package:json_annotation/json_annotation.dart';

part 'chatsen_badge.g.dart';

@JsonSerializable()
class ChatsenBadge {
  String id;
  String name;
  String? description;
  List<String> mipmap;
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
