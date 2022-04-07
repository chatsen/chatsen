import 'package:chatsen/api/chatsen/chatsen_broadcastsettings.dart';
import 'package:chatsen/api/chatsen/chatsen_followers.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chatsen_channel.dart';
import 'chatsen_stream.dart';

part 'chatsen_user.g.dart';

@JsonSerializable()
class ChatsenUser {
  String id;
  String login;
  String displayName;
  String profileImageURL;
  String? bannerImageURL;
  String? offlineImageURL;
  int profileViewCount;
  String? primaryColorHex;
  ChatsenStream? stream;
  ChatsenBroadcastSettings broadcastSettings;
  ChatsenFollowers followers;
  ChatsenChannel? channel;

  ChatsenUser({
    required this.id,
    required this.login,
    required this.displayName,
    required this.profileImageURL,
    required this.bannerImageURL,
    required this.offlineImageURL,
    required this.profileViewCount,
    required this.primaryColorHex,
    required this.stream,
    required this.broadcastSettings,
    required this.followers,
    required this.channel,
  });

  factory ChatsenUser.fromJson(Map<String, dynamic> json) => _$ChatsenUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsenUserToJson(this);
}
