import 'package:chatsen/api/chatsen/chatsen_chatters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatsen_channel.g.dart';

@JsonSerializable()
class ChatsenChannel {
  ChatsenChatters chatters;

  ChatsenChannel({
    required this.chatters,
  });

  factory ChatsenChannel.fromJson(Map<String, dynamic> json) => _$ChatsenChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenChannelToJson(this);
}
