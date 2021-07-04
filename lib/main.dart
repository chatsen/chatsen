import 'dart:io';

import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:chatsen/Badges/ChatterinoBadges.dart';
import 'package:chatsen/Badges/FFZBadges.dart';
import 'package:chatsen/Commands/CommandsCubit.dart';
import 'package:chatsen/Theme/ThemeBloc.dart';
import 'package:dart_downloader/DownloadManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'Accounts/AccountModel.dart';
import 'App.dart';
import 'AudioBackground/AudioBackgroundCubit.dart';
import 'Badges/ChatsenBadges.dart';
import 'Badges/FFZAPBadges.dart';
import 'Badges/SevenTVBadges.dart';
import 'Mentions/MentionsCubit.dart';
import 'Settings/Settings.dart';
import 'StreamOverlay/StreamOverlayBloc.dart';

/// The main function is the entry point of our application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.transparent,
  // ));
  // await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  // if (Platform.isAndroid) {
  //   var deviceInfo = DeviceInfoPlugin();
  //   var androidInfo = await deviceInfo.androidInfo;
  //   // if (androidInfo.version.sdkInt! >= 21) await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  // }

  if (Platform.isAndroid || Platform.isIOS) {
    await Hive.initFlutter();
  } else {
    Hive.init('.');
  }

  Hive.registerAdapter(AccountModelAdapter());

  var settingsBox = await Hive.openBox('Settings');
  var commandsBox = await Hive.openBox('Commands');
  var themeBox = await Hive.openBox('Theme');
  var accountsBox = await Hive.openBox('Accounts');

  // timeDilation = 4.0;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AudioBackgroundCubit()),
        BlocProvider(create: (BuildContext context) => CommandsCubit(commandsBox)),
        BlocProvider(create: (BuildContext context) => AccountsCubit(accountsBox)),
        BlocProvider(create: (BuildContext context) => FFZAPBadges()),
        BlocProvider(create: (BuildContext context) => FFZBadges()),
        BlocProvider(create: (BuildContext context) => ChatterinoBadges()),
        BlocProvider(create: (BuildContext context) => SevenTVBadges()),
        BlocProvider(create: (BuildContext context) => ChatsenBadges()),
        BlocProvider(create: (BuildContext context) => MentionsCubit()),
        BlocProvider(create: (BuildContext context) => ThemeBloc(themeBox, mode: ThemeMode.dark, colorScheme: 'red')),
        BlocProvider(create: (BuildContext context) => DownloadManager()),
        BlocProvider(create: (BuildContext context) => StreamOverlayBloc()),
        BlocProvider(create: (BuildContext context) => Settings(settingsBox)),
      ],
      child: App(),
    ),
  );
  // await Hive.close();
}
