// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seventv_cosmetics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SevenTVCosmetics _$SevenTVCosmeticsFromJson(Map<String, dynamic> json) =>
    SevenTVCosmetics(
      badges: (json['badges'] as List<dynamic>)
          .map((e) => SevenTVBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SevenTVCosmeticsToJson(SevenTVCosmetics instance) =>
    <String, dynamic>{
      'badges': instance.badges,
    };
