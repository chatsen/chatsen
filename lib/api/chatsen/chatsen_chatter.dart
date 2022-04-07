import 'package:json_annotation/json_annotation.dart';

part 'chatsen_chatter.g.dart';

@JsonSerializable()
class ChatsenChatter {
  String id;
  String login;
  String displayName;
  String? chatColor;
  String profileImageURL;

  ChatsenChatter({
    required this.id,
    required this.login,
    required this.displayName,
    required this.chatColor,
    required this.profileImageURL,
  });

  factory ChatsenChatter.fromJson(Map<String, dynamic> json) => _$ChatsenChatterFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenChatterToJson(this);
}
