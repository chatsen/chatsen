// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenStream _$ChatsenStreamFromJson(Map<String, dynamic> json) =>
    ChatsenStream(
      game: ChatsenGame.fromJson(json['game'] as Map<String, dynamic>),
      previewImageURL: json['previewImageURL'] as String,
      viewersCount: json['viewersCount'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ChatsenStreamToJson(ChatsenStream instance) =>
    <String, dynamic>{
      'game': instance.game,
      'previewImageURL': instance.previewImageURL,
      'viewersCount': instance.viewersCount,
      'createdAt': instance.createdAt,
    };
