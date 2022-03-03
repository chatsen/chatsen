// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betterttv_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BetterTTVUser _$BetterTTVUserFromJson(Map<String, dynamic> json) =>
    BetterTTVUser(
      id: json['id'] as String,
      avatar: json['avatar'] as String,
      channelEmotes: (json['channelEmotes'] as List<dynamic>)
          .map((e) => BetterTTVEmote.fromJson(e as Map<String, dynamic>))
          .toList(),
      sharedEmotes: (json['sharedEmotes'] as List<dynamic>)
          .map((e) => BetterTTVEmote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BetterTTVUserToJson(BetterTTVUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'channelEmotes': instance.channelEmotes,
      'sharedEmotes': instance.sharedEmotes,
    };
