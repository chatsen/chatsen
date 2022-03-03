// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZRoom _$FrankerFaceZRoomFromJson(Map<String, dynamic> json) =>
    FrankerFaceZRoom(
      id: json['_id'] as int,
      twitchId: json['twitch_id'] as int?,
      youtubeId: json['youtube_id'],
      setId: json['set'] as int,
      vipBadge: (json['vip_badge'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      modUrls: (json['mod_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$FrankerFaceZRoomToJson(FrankerFaceZRoom instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'twitch_id': instance.twitchId,
      'youtube_id': instance.youtubeId,
      'set': instance.setId,
      'vip_badge': instance.vipBadge,
      'mod_urls': instance.modUrls,
    };
