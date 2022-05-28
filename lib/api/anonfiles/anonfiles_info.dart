import 'package:json_annotation/json_annotation.dart';

part 'anonfiles_info.g.dart';

@JsonSerializable()
class AnonfilesFileInfoMetadataSize {
  final int bytes;
  final String readable;

  const AnonfilesFileInfoMetadataSize({
    required this.bytes,
    required this.readable,
  });

  factory AnonfilesFileInfoMetadataSize.fromJson(Map<String, dynamic> json) => _$AnonfilesFileInfoMetadataSizeFromJson(json);
  Map<String, dynamic> toJson() => _$AnonfilesFileInfoMetadataSizeToJson(this);
}

@JsonSerializable()
class AnonfilesFileInfoMetadata {
  final String id;
  final String name;
  final AnonfilesFileInfoMetadataSize size;

  const AnonfilesFileInfoMetadata({
    required this.id,
    required this.name,
    required this.size,
  });

  factory AnonfilesFileInfoMetadata.fromJson(Map<String, dynamic> json) => _$AnonfilesFileInfoMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$AnonfilesFileInfoMetadataToJson(this);
}

@JsonSerializable()
class AnonfilesFileInfoUrls {
  final String full;
  final String short;

  const AnonfilesFileInfoUrls({
    required this.full,
    required this.short,
  });

  factory AnonfilesFileInfoUrls.fromJson(Map<String, dynamic> json) => _$AnonfilesFileInfoUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$AnonfilesFileInfoUrlsToJson(this);
}

@JsonSerializable()
class AnonfilesFileInfo {
  final AnonfilesFileInfoMetadata metadata;
  final AnonfilesFileInfoUrls url;

  const AnonfilesFileInfo({
    required this.metadata,
    required this.url,
  });

  factory AnonfilesFileInfo.fromJson(Map<String, dynamic> json) => _$AnonfilesFileInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AnonfilesFileInfoToJson(this);
}
