// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dankchat_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DankChatBadge _$DankChatBadgeFromJson(Map<String, dynamic> json) =>
    DankChatBadge(
      type: json['type'] as String,
      url: json['url'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DankChatBadgeToJson(DankChatBadge instance) =>
    <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      'users': instance.users,
    };
