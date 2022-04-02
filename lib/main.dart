import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:chatsen/data/settings/message_appearance.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import '/data/twitch_account.dart';
import '/data/webview/cookie_data.dart';
import '/app.dart';
import 'data/filesharing/uploaded_media.dart';
import 'tmi/client/client.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TwitchAccountAdapter());
  Hive.registerAdapter(TokenDataAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(CookieDataAdapter());
  Hive.registerAdapter(UploadedMediaAdapter());
  Hive.registerAdapter(MessageAppearanceAdapter());
  Hive.registerAdapter(ApplicationAppearanceAdapter());

  final twitchAccountsBox = await Hive.openBox('TwitchAccounts');
  final accountSettingsBox = await Hive.openBox('AccountSettings');
  final settingsBox = await Hive.openBox('Settings');

  await settingsBox.clear();

  final activeTwitchAccount = twitchAccountsBox.values.firstWhere(
    (element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash,
    orElse: () => null,
  );

  if (!settingsBox.containsKey('messageAppearance')) await settingsBox.put('messageAppearance', MessageAppearance());

  runApp(
    MultiProvider(
      providers: [
        Provider<Client>(create: (context) => Client(twitchAccount: activeTwitchAccount)),
      ],
      child: const App(),
    ),
  );
}
