// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZUser _$FrankerFaceZUserFromJson(Map<String, dynamic> json) =>
    FrankerFaceZUser(
      room: FrankerFaceZRoom.fromJson(json['room'] as Map<String, dynamic>),
      sets: (json['sets'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, FrankerFaceZSet.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$FrankerFaceZUserToJson(FrankerFaceZUser instance) =>
    <String, dynamic>{
      'room': instance.room,
      'sets': instance.sets,
    };
