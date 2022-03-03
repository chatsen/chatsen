// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZSet _$FrankerFaceZSetFromJson(Map<String, dynamic> json) =>
    FrankerFaceZSet(
      id: json['id'] as int,
      type: json['_type'] as int,
      title: json['title'] as String,
      emoticons: (json['emoticons'] as List<dynamic>)
          .map((e) => FrankerFaceZEmote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FrankerFaceZSetToJson(FrankerFaceZSet instance) =>
    <String, dynamic>{
      'id': instance.id,
      '_type': instance.type,
      'title': instance.title,
      'emoticons': instance.emoticons,
    };
