import 'package:json_annotation/json_annotation.dart';

part 'chatsen_vendor.g.dart';

@JsonSerializable()
class ChatsenBuild {
  String channel;
  String version;
  String? url;
  String? changelog;

  ChatsenBuild({
    required this.channel,
    required this.version,
    this.url,
    this.changelog,
  });

  factory ChatsenBuild.fromJson(Map<String, dynamic> json) => _$ChatsenBuildFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenBuildToJson(this);
}

@JsonSerializable()
class ChatsenPlatform {
  String id;
  String name;
  String? url;
  Map<String, ChatsenBuild> builds;

  ChatsenPlatform({
    required this.id,
    required this.name,
    this.url,
    required this.builds,
  });

  factory ChatsenPlatform.fromJson(Map<String, dynamic> json) => _$ChatsenPlatformFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenPlatformToJson(this);
}

@JsonSerializable()
class ChatsenVendor {
  String id;
  String name;
  String? url;
  Map<String, ChatsenPlatform> platforms;

  ChatsenVendor({
    required this.id,
    required this.name,
    this.url,
    required this.platforms,
  });

  factory ChatsenVendor.fromJson(Map<String, dynamic> json) => _$ChatsenVendorFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenVendorToJson(this);
}
