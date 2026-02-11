import 'dart:io';

import '/Accounts/AccountsCubit.dart';
import '/DataExport.dart';
import '/Badges/ChatterinoBadges.dart';
import '/Badges/DankChatBadges.dart';
import '/Badges/FFZBadges.dart';
import '/BlockedTerms/BlockedTermsCubit.dart';
import '/BlockedUsers/BlockedUsersCubit.dart';
import '/Commands/Command.dart';
import '/Commands/CommandsCubit.dart';
import '/Consts.dart';
import '/Mentions/CustomMention.dart';
import '/Theme/ThemeBloc.dart';
// import 'package:dart_downloader/DownloadManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

import 'Accounts/AccountModel.dart';
import 'App.dart';
import 'BackgroundDaemon/BackgroundDaemonCubit.dart';
import 'Badges/BTTVBadges.dart';
import 'Badges/Chatsen2Badges.dart';
import 'Badges/ChatsenBadges.dart';
import 'Badges/ChattyBadges.dart';
import 'Badges/FFZAPBadges.dart';
import 'Badges/SevenTVBadges.dart';
import 'Mentions/CustomMentionsCubit.dart';
import 'Mentions/MentionsCubit.dart';
import 'Settings/Settings.dart';
import 'StreamOverlay/StreamOverlayBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> appRunner() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WakelockPlus.enable();

  if (Platform.isAndroid || Platform.isIOS) {
    await Hive.initFlutter();
  } else {
    Hive.init('.');
  }

  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(CommandAdapter());
  Hive.registerAdapter(CustomMentionAdapter());

  var settingsBox = await Hive.openBox('Settings');
  var commandsBox = await Hive.openBox('Commands');
  var customMentionsBox = await Hive.openBox('CustomMentions');
  var blockedTermsBox = await Hive.openBox('BlockedTerms');
  var blockedUsersBox = await Hive.openBox('BlockedUsers');
  var themeBox = await Hive.openBox('Theme');
  var accountsBox = await Hive.openBox('Accounts');

  // Backup all data to SharedPreferences on launch
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatsen1backup', buildExportJson(
      settingsBox: settingsBox,
      themeBox: themeBox,
      accountsBox: accountsBox,
      commandsBox: commandsBox,
      customMentionsBox: customMentionsBox,
      blockedUsersBox: blockedUsersBox,
    ));
  } catch (_) {}

  // timeDilation = 4.0;

  runApp(
    MultiBlocProvider(
      providers: [
        if (!kPlayStoreRelease) BlocProvider(create: (BuildContext context) => BackgroundDaemonCubit()),
        BlocProvider(create: (BuildContext context) => CommandsCubit(commandsBox)),
        BlocProvider(create: (BuildContext context) => CustomMentionsCubit(customMentionsBox)),
        BlocProvider(create: (BuildContext context) => AccountsCubit(accountsBox)),
        BlocProvider(create: (BuildContext context) => FFZAPBadges()),
        BlocProvider(create: (BuildContext context) => FFZBadges()),
        BlocProvider(create: (BuildContext context) => BTTVBadges()),
        BlocProvider(create: (BuildContext context) => ChattyBadges()),
        BlocProvider(create: (BuildContext context) => ChatterinoBadges()),
        BlocProvider(create: (BuildContext context) => DankChatBadges()),
        BlocProvider(create: (BuildContext context) => SevenTVBadges()),
        BlocProvider(create: (BuildContext context) => ChatsenBadges()),
        BlocProvider(create: (BuildContext context) => Chatsen2Badges()),
        BlocProvider(create: (BuildContext context) => MentionsCubit()),
        BlocProvider(create: (BuildContext context) => ThemeBloc(themeBox, mode: ThemeMode.dark, colorScheme: 'cyan')),
        // BlocProvider(create: (BuildContext context) => DownloadManager()),
        BlocProvider(create: (BuildContext context) => StreamOverlayBloc()),
        BlocProvider(create: (BuildContext context) => Settings(settingsBox)),
        BlocProvider(create: (BuildContext context) => BlockedUsersCubit(blockedUsersBox)),
        BlocProvider(create: (BuildContext context) => BlockedTermsCubit(blockedTermsBox)),
      ],
      child: App(),
    ),
  );
  // await Hive.close();
}

/// The main function is the entry point of our application.
void main() async {
  if (kReleaseMode) {
    // await SentryFlutter.init(
    //   (options) {
    //     options.dsn = 'https://27538e5be8ea45bd97bf0875ba6e756c@sentry.chatsen.app/4';
    //   },
    //   appRunner: appRunner,
    // );
    await appRunner();

  } else {
    await appRunner();
  }
}
