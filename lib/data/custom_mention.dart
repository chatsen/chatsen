import 'package:hive_flutter/hive_flutter.dart';

part 'custom_mention.g.dart';

@HiveType(typeId: 13)
class CustomMention extends HiveObject {
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

  CustomMention({
    required this.pattern,
    this.enableRegex = false,
    this.caseSensitive = false,
    this.showInMentions = true,
    this.sendNotification = true,
    this.playSound = true,
  });
}
