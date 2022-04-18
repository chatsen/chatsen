import 'package:hive_flutter/hive_flutter.dart';

part 'mention_message.g.dart';

@HiveType(typeId: 10)
class MentionMessage extends HiveObject {
  @HiveField(0)
  String pattern;

  @HiveField(1)
  bool notify;

  @HiveField(2)
  bool enableRegex;

  @HiveField(3)
  bool caseSensitive;

  MentionMessage({
    required this.pattern,
    required this.notify,
    required this.enableRegex,
    required this.caseSensitive,
  });
}
