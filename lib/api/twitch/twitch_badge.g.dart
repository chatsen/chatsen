// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchBadge _$TwitchBadgeFromJson(Map<String, dynamic> json) => TwitchBadge(
      imageUrl1x: json['image_url_1x'] as String,
      imageUrl2x: json['image_url_2x'] as String,
      imageUrl4x: json['image_url_4x'] as String,
      description: json['description'] as String?,
      title: json['title'] as String,
    );

Map<String, dynamic> _$TwitchBadgeToJson(TwitchBadge instance) =>
    <String, dynamic>{
      'image_url_1x': instance.imageUrl1x,
      'image_url_2x': instance.imageUrl2x,
      'image_url_4x': instance.imageUrl4x,
      'description': instance.description,
      'title': instance.title,
    };
