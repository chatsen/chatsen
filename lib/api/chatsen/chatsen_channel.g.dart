// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenChannel _$ChatsenChannelFromJson(Map<String, dynamic> json) =>
    ChatsenChannel(
      chatters:
          ChatsenChatters.fromJson(json['chatters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatsenChannelToJson(ChatsenChannel instance) =>
    <String, dynamic>{
      'chatters': instance.chatters,
    };
