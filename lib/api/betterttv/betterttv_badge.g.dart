// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betterttv_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BetterTTVBadge _$BetterTTVBadgeFromJson(Map<String, dynamic> json) =>
    BetterTTVBadge(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      providerId: json['providerId'] as String,
      badge: BetterTTVBadgeInfo.fromJson(json['badge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BetterTTVBadgeToJson(BetterTTVBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'providerId': instance.providerId,
      'badge': instance.badge,
    };
