import 'package:json_annotation/json_annotation.dart';

import 'chatsen_chatter.dart';

part 'chatsen_chatters.g.dart';

@JsonSerializable()
class ChatsenChatters {
  List<ChatsenChatter> staff;
  List<ChatsenChatter> broadcasters;
  List<ChatsenChatter> moderators;
  List<ChatsenChatter> vips;
  List<ChatsenChatter> viewers;
  int count;

  ChatsenChatters({
    required this.staff,
    required this.broadcasters,
    required this.moderators,
    required this.vips,
    required this.viewers,
    required this.count,
  });

  factory ChatsenChatters.fromJson(Map<String, dynamic> json) => _$ChatsenChattersFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenChattersToJson(this);
}
