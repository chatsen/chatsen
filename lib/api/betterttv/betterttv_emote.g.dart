// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betterttv_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BetterTTVEmote _$BetterTTVEmoteFromJson(Map<String, dynamic> json) =>
    BetterTTVEmote(
      id: json['id'] as String,
      code: json['code'] as String,
      imageType: json['imageType'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$BetterTTVEmoteToJson(BetterTTVEmote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'imageType': instance.imageType,
      'userId': instance.userId,
    };
