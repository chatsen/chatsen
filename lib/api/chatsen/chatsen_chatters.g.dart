// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_chatters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenChatters _$ChatsenChattersFromJson(Map<String, dynamic> json) =>
    ChatsenChatters(
      staff: (json['staff'] as List<dynamic>)
          .map((e) => ChatsenChatter.fromJson(e as Map<String, dynamic>))
          .toList(),
      broadcasters: (json['broadcasters'] as List<dynamic>)
          .map((e) => ChatsenChatter.fromJson(e as Map<String, dynamic>))
          .toList(),
      moderators: (json['moderators'] as List<dynamic>)
          .map((e) => ChatsenChatter.fromJson(e as Map<String, dynamic>))
          .toList(),
      vips: (json['vips'] as List<dynamic>)
          .map((e) => ChatsenChatter.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewers: (json['viewers'] as List<dynamic>)
          .map((e) => ChatsenChatter.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
    );

Map<String, dynamic> _$ChatsenChattersToJson(ChatsenChatters instance) =>
    <String, dynamic>{
      'staff': instance.staff,
      'broadcasters': instance.broadcasters,
      'moderators': instance.moderators,
      'vips': instance.vips,
      'viewers': instance.viewers,
      'count': instance.count,
    };
