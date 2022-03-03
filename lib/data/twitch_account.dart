import 'package:hive/hive.dart';

import 'twitch/token_data.dart';
import 'twitch/user_data.dart';
import 'webview/cookie_data.dart';

part 'twitch_account.g.dart';

@HiveType(typeId: 1)
class TwitchAccount extends HiveObject {
  @HiveField(0)
  TokenData tokenData;

  @HiveField(1)
  UserData? userData;

  @HiveField(2)
  List<CookieData>? cookies;

  TwitchAccount({
    required this.tokenData,
    required this.userData,
    required this.cookies,
  });
}
