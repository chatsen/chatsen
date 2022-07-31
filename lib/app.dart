import 'dart:io';

import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/tools/m3parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/boxlistener.dart';
import 'data/settings/application_appearance.dart';
import 'pages/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  static int windowsBuildVersion() {
    try {
      RegExp regex = RegExp(r'.*\(Build (.*)\).*');
      String version = regex.firstMatch(Platform.operatingSystemVersion)!.group(1)!;
      return int.parse(version);
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) => BoxListener(
        box: Hive.box('Settings'),
        builder: (context, box) {
          final ApplicationAppearance applicationAppearance = box.get('applicationAppearance') as ApplicationAppearance;
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: null,
            debugShowCheckedModeBanner: false,
            home: Builder(builder: (context) {
              if (Platform.isWindows) {
                int winver = windowsBuildVersion();
                if (winver < 22000) {
                  Window.setEffect(
                    effect: WindowEffect.acrylic,
                    dark: Theme.of(context).brightness == Brightness.dark,
                    // color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
                  );
                } else {
                  Window.setEffect(
                    effect: WindowEffect.mica,
                    dark: Theme.of(context).brightness == Brightness.dark,
                    color: Theme.of(context).colorScheme.primary,
                  );
                }
              }
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                  statusBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.light,
                  statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark,
                  statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
                ),
                child: Stack(
                  children: [
                    const HomePage(),
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                  ],
                ),
              );
            }),
            // theme: M3Parser.parse(M3Themes.themes['green']!, dark: false),
            // darkTheme: M3Parser.parse(M3Themes.themes['green']!, dark: true),
            theme: M3Parser.patchTheme(
              ThemeData(
                colorSchemeSeed: Color(box.get('themeColor') as int? ?? 0xFF00FF00),
                brightness: Brightness.light,
              ),
            ),
            darkTheme: M3Parser.patchTheme(
              ThemeData(
                colorSchemeSeed: Color(box.get('themeColor') as int? ?? 0xFF00FF00),
                brightness: Brightness.dark,
              ),
            ),
            themeMode: applicationAppearance.themeMode == 'dark'
                ? ThemeMode.dark
                : applicationAppearance.themeMode == 'light'
                    ? ThemeMode.light
                    : ThemeMode.system,
          );
        },
      );
}
