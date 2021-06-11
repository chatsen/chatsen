import 'dart:io';

import 'package:chatsen/Theme/ThemeBloc.dart';
import 'package:dart_downloader/DownloadManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'App.dart';
import 'MVP/Models/AccountModel.dart';
import 'Mentions/MentionsCubit.dart';
import 'Settings/Settings.dart';
import 'StreamOverlay/StreamOverlayBloc.dart';

/// The main function is the entry point of our application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));

  if (Platform.isAndroid) {
    var deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt! >= 21) await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  if (Platform.isAndroid || Platform.isIOS) {
    await Hive.initFlutter();
  } else {
    Hive.init('.');
  }
  Hive.registerAdapter(AccountModelAdapter());
  await Hive.openBox('Accounts');
  await Hive.openBox('SettingsOld');

  var settingsBox = await Hive.openBox('Settings');
  var themeBox = await Hive.openBox('Theme');

  runApp(
    MultiBlocProvider(
      providers: [
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
