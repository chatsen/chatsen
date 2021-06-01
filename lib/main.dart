import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/MVP/Presenters/AutocompletePresenter.dart';
import '/MVP/Presenters/MessagePresenter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info/device_info.dart';

import 'App.dart';
import 'MVP/Models/AccountModel.dart';
import 'MVP/Presenters/NotificationPresenter.dart';
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
    if (androidInfo.version.sdkInt >= 21) await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  await Hive.initFlutter();
  // await Hive.init('.');
  await Hive.registerAdapter(AccountModelAdapter());
  await Hive.openBox('Settings');
  await Hive.openBox('Accounts');
  await NotificationPresenter.loadData();
  await MessagePresenter.loadData();
  await AutocompletePresenter.loadData();
  runApp(
    BlocProvider(
      create: (BuildContext context) => StreamOverlayBloc(),
      child: App(),
    ),
  );
  await Hive.close();
}
