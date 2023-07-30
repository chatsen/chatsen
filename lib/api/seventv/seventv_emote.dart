import 'package:json_annotation/json_annotation.dart';

part 'seventv_emote.g.dart';

@JsonSerializable()
class SevenTVEmoteDataOwner {
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;

  @JsonKey(name: 'display_name')
  String displayName;

  String id;
  List<String>? roles;
  Map<String, dynamic> style;
  String username;

  SevenTVEmoteDataOwner({
    required this.avatarUrl,
    required this.displayName,
    required this.id,
    required this.roles,
    required this.style,
    required this.username,
  });

  factory SevenTVEmoteDataOwner.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteDataOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteDataOwnerToJson(this);
}

@JsonSerializable()
class SevenTVEmoteDataHostFile {
  String format;

  @JsonKey(name: 'frame_count')
  int frameCount;

  int height;
  String name;

  int size;

  @JsonKey(name: 'static_name')
  String staticName;

  int width;

  SevenTVEmoteDataHostFile({
    required this.format,
    required this.frameCount,
    required this.height,
    required this.name,
    required this.size,
    required this.staticName,
    required this.width,
  });

  factory SevenTVEmoteDataHostFile.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteDataHostFileFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteDataHostFileToJson(this);
}

@JsonSerializable()
class SevenTVEmoteDataHost {
  String url;
  List<SevenTVEmoteDataHostFile> files;

  SevenTVEmoteDataHost({
    required this.url,
    required this.files,
  });

  factory SevenTVEmoteDataHost.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteDataHostFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteDataHostToJson(this);
}

@JsonSerializable()
class SevenTVEmoteData {
  bool animated;
  int flags;
  SevenTVEmoteDataHost host;
  String id;
  int lifecycle;
  bool listed;
  String name;
  SevenTVEmoteDataOwner owner;
  List<String> state;

  SevenTVEmoteData({
    required this.animated,
    required this.flags,
    required this.host,
    required this.id,
    required this.lifecycle,
    required this.listed,
    required this.name,
    required this.owner,
    required this.state,
  });

  factory SevenTVEmoteData.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteDataToJson(this);
}

@JsonSerializable()
class SevenTVEmote {
  SevenTVEmoteData data;
  int flags;
  String id;
  String name;
  int timestamp;

  SevenTVEmote({
    required this.data,
    required this.flags,
    required this.id,
    required this.name,
    required this.timestamp,
  });

  factory SevenTVEmote.fromJson(Map<String, dynamic> json) => _$SevenTVEmoteFromJson(json);

  Map<String, dynamic> toJson() => _$SevenTVEmoteToJson(this);
}
