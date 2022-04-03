import 'package:json_annotation/json_annotation.dart';

part 'chatsen_broadcastsettings.g.dart';

@JsonSerializable()
class ChatsenBroadcastSettings {
  String title;

  ChatsenBroadcastSettings({
    required this.title,
  });

  factory ChatsenBroadcastSettings.fromJson(Map<String, dynamic> json) => _$ChatsenBroadcastSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenBroadcastSettingsToJson(this);
}
