import 'package:hive_flutter/hive_flutter.dart';

part 'message_trigger.g.dart';

enum MessageTriggerType {
  Mention,
  Block,
}

@HiveType(typeId: 13)
class MessageTrigger extends HiveObject {
  @HiveField(0)
  String pattern;

  @HiveField(1)
  bool enableRegex;

  @HiveField(2)
  bool caseSensitive;

  @HiveField(3)
  bool showInMentions;

  @HiveField(4)
  bool sendNotification;

  @HiveField(5)
  bool playSound;

  @HiveField(6)
  MessageTriggerType type;

  MessageTrigger({
    required this.pattern,
    this.enableRegex = false,
    this.caseSensitive = false,
    this.showInMentions = true,
    this.sendNotification = true,
    this.playSound = true,
    this.type = MessageTriggerType.Mention,
  });
}
