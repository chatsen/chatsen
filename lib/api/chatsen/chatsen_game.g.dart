// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenGame _$ChatsenGameFromJson(Map<String, dynamic> json) => ChatsenGame(
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      avatarURL: json['avatarURL'] as String,
    );

Map<String, dynamic> _$ChatsenGameToJson(ChatsenGame instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'description': instance.description,
      'name': instance.name,
      'avatarURL': instance.avatarURL,
    };
