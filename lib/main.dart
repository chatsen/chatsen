import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatsen/data/custom_command.dart';
import 'package:chatsen/data/message_trigger.dart';
import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:chatsen/data/settings/blocked_message.dart';
import 'package:chatsen/data/settings/blocked_user.dart';
import 'package:chatsen/data/settings/mention_message.dart';
import 'package:chatsen/data/settings/mention_user.dart';
import 'package:chatsen/data/settings/message_appearance.dart';
import 'package:chatsen/data/user_trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import '/data/twitch_account.dart';
import '/data/webview/cookie_data.dart';
import '/app.dart';
import 'data/filesharing/uploaded_media.dart';
import 'tmi/client/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await Window.initialize();
  }

  await Wakelock.enable();

  await Hive.initFlutter();

  Hive.registerAdapter(TwitchAccountAdapter());
  Hive.registerAdapter(TokenDataAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(CookieDataAdapter());
  Hive.registerAdapter(UploadedMediaAdapter());
  Hive.registerAdapter(MessageAppearanceAdapter());
  Hive.registerAdapter(ApplicationAppearanceAdapter());
  Hive.registerAdapter(BlockedMessageAdapter());
  Hive.registerAdapter(BlockedUserAdapter());
  Hive.registerAdapter(MentionMessageAdapter());
  Hive.registerAdapter(MentionUserAdapter());
  Hive.registerAdapter(CustomCommandAdapter());
  Hive.registerAdapter(MessageTriggerAdapter());
  Hive.registerAdapter(UserTriggerAdapter());

  final twitchAccountsBox = await Hive.openBox('TwitchAccounts');
  final accountSettingsBox = await Hive.openBox('AccountSettings');
  final settingsBox = await Hive.openBox('Settings');

  await Hive.openBox('MessageTriggers');
  await Hive.openBox('UserTriggers');
  await Hive.openBox('CustomCommands');

  // await settingsBox.clear();

  final activeTwitchAccount = twitchAccountsBox.values.firstWhere(
    (element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash,
    orElse: () => null,
  );

  if (!settingsBox.containsKey('messageAppearance')) await settingsBox.put('messageAppearance', MessageAppearance());
  if (!settingsBox.containsKey('applicationAppearance')) await settingsBox.put('applicationAppearance', ApplicationAppearance());

  runApp(
    MultiProvider(
      providers: [
        Provider<Client>(create: (context) => Client(twitchAccount: activeTwitchAccount)),
      ],
      child: const App(),
    ),
  );

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(240 + 128, 768);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}
