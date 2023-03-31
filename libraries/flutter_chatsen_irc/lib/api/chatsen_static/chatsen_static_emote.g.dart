// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatsen_static_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsenStaticEmote _$ChatsenStaticEmoteFromJson(Map<String, dynamic> json) =>
    ChatsenStaticEmote(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      modifiers: json['modifiers'] as int,
    );

Map<String, dynamic> _$ChatsenStaticEmoteToJson(ChatsenStaticEmote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'modifiers': instance.modifiers,
    };
