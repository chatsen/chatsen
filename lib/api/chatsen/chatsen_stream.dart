import 'package:json_annotation/json_annotation.dart';

import 'chatsen_game.dart';

part 'chatsen_stream.g.dart';

@JsonSerializable()
class ChatsenStream {
  ChatsenGame game;
  String previewImageURL;
  String viewersCount;
  String createdAt;

  ChatsenStream({
    required this.game,
    required this.previewImageURL,
    required this.viewersCount,
    required this.createdAt,
  });

  factory ChatsenStream.fromJson(Map<String, dynamic> json) => _$ChatsenStreamFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenStreamToJson(this);
}
