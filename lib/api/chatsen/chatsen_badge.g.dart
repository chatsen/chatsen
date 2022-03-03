// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenBadge _$ChatsenBadgeFromJson(Map<String, dynamic> json) => ChatsenBadge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      mipmap:
          (json['mipmap'] as List<dynamic>).map((e) => e as String).toList(),
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatsenBadgeToJson(ChatsenBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'mipmap': instance.mipmap,
      'users': instance.users,
    };
