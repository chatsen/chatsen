import 'dart:ui';

import '/tools/m3parser.dart';
import '/tools/m3themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: null,
        debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark,
            statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          ),
          child: const HomePage(),
        ),
        theme: M3Parser.parse(M3Themes.themes['blue']!, dark: false),
        darkTheme: M3Parser.parse(M3Themes.themes['blue']!, dark: true),
        themeMode: ThemeMode.dark,
      );
}
