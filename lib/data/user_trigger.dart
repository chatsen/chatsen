import 'package:hive_flutter/hive_flutter.dart';

part 'user_trigger.g.dart';

enum UserTriggerType {
  mention,
  block,
}

@HiveType(typeId: 14)
class UserTrigger extends HiveObject {
  @HiveField(0)
  int type;

  @HiveField(1)
  String login;

  @HiveField(2)
  bool enableRegex;

  @HiveField(3)
  bool caseSensitive;

  @HiveField(4)
  bool showInMentions;

  @HiveField(5)
  bool sendNotification;

  @HiveField(6)
  bool playSound;

  UserTrigger({
    required this.type,
    required this.login,
    this.enableRegex = false,
    this.caseSensitive = false,
    this.showInMentions = true,
    this.sendNotification = true,
    this.playSound = true,
  });
}
