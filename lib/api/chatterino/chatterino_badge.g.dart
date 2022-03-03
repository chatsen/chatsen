// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatterino_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatterinoBadge _$ChatterinoBadgeFromJson(Map<String, dynamic> json) =>
    ChatterinoBadge(
      image1: json['image1'] as String,
      image2: json['image2'] as String,
      image3: json['image3'] as String,
      tooltip: json['tooltip'] as String,
      badges:
          (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatterinoBadgeToJson(ChatterinoBadge instance) =>
    <String, dynamic>{
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'tooltip': instance.tooltip,
      'badges': instance.badges,
    };
