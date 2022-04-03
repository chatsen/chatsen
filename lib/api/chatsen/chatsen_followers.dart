import 'package:json_annotation/json_annotation.dart';

part 'chatsen_followers.g.dart';

@JsonSerializable()
class ChatsenFollowers {
  int totalCount;

  ChatsenFollowers({
    required this.totalCount,
  });

  factory ChatsenFollowers.fromJson(Map<String, dynamic> json) => _$ChatsenFollowersFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenFollowersToJson(this);
}
