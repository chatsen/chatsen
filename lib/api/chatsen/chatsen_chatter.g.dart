// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_chatter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenChatter _$ChatsenChatterFromJson(Map<String, dynamic> json) =>
    ChatsenChatter(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['displayName'] as String,
      chatColor: json['chatColor'] as String?,
      profileImageURL: json['profileImageURL'] as String,
    );

Map<String, dynamic> _$ChatsenChatterToJson(ChatsenChatter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'displayName': instance.displayName,
      'chatColor': instance.chatColor,
      'profileImageURL': instance.profileImageURL,
    };
