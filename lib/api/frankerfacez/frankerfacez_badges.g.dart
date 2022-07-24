// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankerfacez_badges.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrankerFaceZBadges _$FrankerFaceZBadgesFromJson(Map<String, dynamic> json) =>
    FrankerFaceZBadges(
      badges: (json['badges'] as List<dynamic>)
          .map((e) => FrankerFaceZBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
      users: (json['users'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as int).toList()),
      ),
    );

Map<String, dynamic> _$FrankerFaceZBadgesToJson(FrankerFaceZBadges instance) =>
    <String, dynamic>{
      'badges': instance.badges,
      'users': instance.users,
    };
