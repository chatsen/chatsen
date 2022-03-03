import 'package:hive/hive.dart';

part 'token_data.g.dart';

@HiveType(typeId: 2)
class TokenData {
  @HiveField(0)
  String? clientId;

  @HiveField(1)
  String login;

  @HiveField(2)
  List<String> scopes;

  @HiveField(3)
  String? userId;

  @HiveField(4)
  DateTime? expiresAt;

  @HiveField(5)
  String? accessToken;

  TokenData({
    required this.clientId,
    required this.login,
    required this.scopes,
    required this.userId,
    required this.expiresAt,
    required this.accessToken,
  });

  String get hash => '$userId@$clientId';
}
