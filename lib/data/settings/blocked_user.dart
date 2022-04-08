import 'package:hive_flutter/hive_flutter.dart';

part 'blocked_user.g.dart';

@HiveType(typeId: 9)
class BlockedUser extends HiveObject {
  @HiveField(0)
  String? login;

  @HiveField(1)
  String? id;

  BlockedUser({
    this.login,
    this.id,
  });
}
