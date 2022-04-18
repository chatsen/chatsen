import 'package:hive_flutter/hive_flutter.dart';

part 'blocked_message.g.dart';

@HiveType(typeId: 8)
class BlockedMessage extends HiveObject {
  @HiveField(0)
  String pattern;

  @HiveField(1)
  bool regex;

  @HiveField(2)
  bool caseSensitive;

  BlockedMessage({
    required this.pattern,
    this.regex = false,
    this.caseSensitive = false,
  });
}
