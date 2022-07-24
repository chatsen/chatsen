// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seventv_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTVBadge _$SevenTVBadgeFromJson(Map<String, dynamic> json) => SevenTVBadge(
      id: json['id'] as String,
      name: json['name'] as String,
      tooltip: json['tooltip'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SevenTVBadgeToJson(SevenTVBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tooltip': instance.tooltip,
      'urls': instance.urls,
      'users': instance.users,
    };
