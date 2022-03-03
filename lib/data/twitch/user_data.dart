import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 3)
class UserData {
  @HiveField(0)
  String displayName;

  @HiveField(1)
  String avatarUrl;

  @HiveField(2)
  String offlineUrl;

  UserData({
    required this.displayName,
    required this.avatarUrl,
    required this.offlineUrl,
  });
}
