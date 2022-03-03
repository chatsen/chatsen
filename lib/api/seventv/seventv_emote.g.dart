// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seventv_emote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTVEmote _$SevenTVEmoteFromJson(Map<String, dynamic> json) => SevenTVEmote(
      id: json['id'] as String,
      name: json['name'] as String,
      visibility: json['visibility'] as int,
      mime: json['mime'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$SevenTVEmoteToJson(SevenTVEmote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'visibility': instance.visibility,
      'mime': instance.mime,
      'urls': instance.urls,
    };
