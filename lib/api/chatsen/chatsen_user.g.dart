// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenUser _$ChatsenUserFromJson(Map<String, dynamic> json) => ChatsenUser(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['displayName'] as String,
      profileImageURL: json['profileImageURL'] as String,
      bannerImageURL: json['bannerImageURL'] as String,
      offlineImageURL: json['offlineImageURL'] as String,
      profileViewCount: json['profileViewCount'] as String,
      primaryColorHex: json['primaryColorHex'] as String,
      stream: ChatsenStream.fromJson(json['stream'] as Map<String, dynamic>),
      broadcastSettings: ChatsenBroadcastSettings.fromJson(
          json['broadcastSettings'] as Map<String, dynamic>),
      followers:
          ChatsenFollowers.fromJson(json['followers'] as Map<String, dynamic>),
      channel: ChatsenChannel.fromJson(json['channel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatsenUserToJson(ChatsenUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'displayName': instance.displayName,
      'profileImageURL': instance.profileImageURL,
      'bannerImageURL': instance.bannerImageURL,
      'offlineImageURL': instance.offlineImageURL,
      'profileViewCount': instance.profileViewCount,
      'primaryColorHex': instance.primaryColorHex,
      'stream': instance.stream,
      'broadcastSettings': instance.broadcastSettings,
      'followers': instance.followers,
      'channel': instance.channel,
    };
