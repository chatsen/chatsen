// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZEmote _$FrankerFaceZEmoteFromJson(Map<String, dynamic> json) =>
    FrankerFaceZEmote(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
      public: json['public'] as bool,
      hidden: json['hidden'] as bool,
      modifier: json['modifier'] as bool,
      urls: Map<String, String>.from(json['urls'] as Map),
      status: json['status'] as int,
      usageCount: json['usage_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$FrankerFaceZEmoteToJson(FrankerFaceZEmote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'width': instance.width,
      'public': instance.public,
      'hidden': instance.hidden,
      'modifier': instance.modifier,
      'urls': instance.urls,
      'status': instance.status,
      'usage_count': instance.usageCount,
      'created_at': instance.createdAt.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
    };
