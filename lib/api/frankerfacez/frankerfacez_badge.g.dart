// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZBadge _$FrankerFaceZBadgeFromJson(Map<String, dynamic> json) =>
    FrankerFaceZBadge(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String,
      slot: json['slot'] as int,
      replaces: json['replaces'] as String?,
      color: json['color'] as String,
      image: json['image'] as String,
      urls: Map<String, String>.from(json['urls'] as Map),
      css: json['css'] as String?,
    );

Map<String, dynamic> _$FrankerFaceZBadgeToJson(FrankerFaceZBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'slot': instance.slot,
      'replaces': instance.replaces,
      'color': instance.color,
      'image': instance.image,
      'urls': instance.urls,
      'css': instance.css,
    };
