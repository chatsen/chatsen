import 'package:hive_flutter/hive_flutter.dart';

part 'mention_user.g.dart';

@HiveType(typeId: 11)
class MentionUser extends HiveObject {
  @HiveField(0)
  String? login;

  @HiveField(1)
  String? id;

  MentionUser({
    this.login,
    this.id,
  });
}
