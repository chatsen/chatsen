// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonfiles_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnonfilesFileInfoMetadataSize _$AnonfilesFileInfoMetadataSizeFromJson(
        Map<String, dynamic> json) =>
    AnonfilesFileInfoMetadataSize(
      bytes: json['bytes'] as int,
      readable: json['readable'] as String,
    );

Map<String, dynamic> _$AnonfilesFileInfoMetadataSizeToJson(
        AnonfilesFileInfoMetadataSize instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'readable': instance.readable,
    };

AnonfilesFileInfoMetadata _$AnonfilesFileInfoMetadataFromJson(
        Map<String, dynamic> json) =>
    AnonfilesFileInfoMetadata(
      id: json['id'] as String,
      name: json['name'] as String,
      size: AnonfilesFileInfoMetadataSize.fromJson(
          json['size'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnonfilesFileInfoMetadataToJson(
        AnonfilesFileInfoMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
    };

AnonfilesFileInfoUrls _$AnonfilesFileInfoUrlsFromJson(
        Map<String, dynamic> json) =>
    AnonfilesFileInfoUrls(
      full: json['full'] as String,
      short: json['short'] as String,
    );

Map<String, dynamic> _$AnonfilesFileInfoUrlsToJson(
        AnonfilesFileInfoUrls instance) =>
    <String, dynamic>{
      'full': instance.full,
      'short': instance.short,
    };

AnonfilesFileInfo _$AnonfilesFileInfoFromJson(Map<String, dynamic> json) =>
    AnonfilesFileInfo(
      metadata: AnonfilesFileInfoMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>),
      url: AnonfilesFileInfoUrls.fromJson(json['url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnonfilesFileInfoToJson(AnonfilesFileInfo instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'url': instance.url,
    };
