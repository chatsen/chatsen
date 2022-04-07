import 'package:json_annotation/json_annotation.dart';

part 'chatsen_game.g.dart';

@JsonSerializable()
class ChatsenGame {
  String displayName;
  String? description;
  String name;
  String avatarURL;

  ChatsenGame({
    required this.displayName,
    required this.description,
    required this.name,
    required this.avatarURL,
  });

  factory ChatsenGame.fromJson(Map<String, dynamic> json) => _$ChatsenGameFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenGameToJson(this);
}
