import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'CustomMention.g.dart';

@HiveType(typeId: 2)
class CustomMention extends HiveObject {
  @HiveField(0)
  String pattern;

  @HiveField(1)
  bool showInMentions;

  @HiveField(2)
  bool sendNotification;

  @HiveField(3)
  bool playSound;

  @HiveField(4)
  bool enableRegex;

  @HiveField(5)
  bool caseSensitive;

  // @HiveField(6)
  // Color? color;

  CustomMention({
    required this.pattern,
    this.showInMentions = true,
    this.sendNotification = true,
    this.playSound = true,
    this.enableRegex = false,
    this.caseSensitive = false,
    // this.color,
  });
}
