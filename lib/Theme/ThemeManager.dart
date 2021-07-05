import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeManager {
  static Map<String, List<dynamic>> colors = {
    'red': [Colors.red, Colors.redAccent],
    'pink': [Colors.pink, Colors.pinkAccent],
    'purple': [Colors.purple, Colors.purpleAccent],
    'deepPurple': [Colors.deepPurple, Colors.deepPurpleAccent],
    'indigo': [Colors.indigo, Colors.indigoAccent],
    'blue': [Colors.blue, Colors.blueAccent],
    'lightBlue': [Colors.lightBlue, Colors.lightBlueAccent],
    'cyan': [Colors.cyan, Colors.cyanAccent],
    'teal': [Colors.teal, Colors.tealAccent],
    'green': [Colors.green, Colors.greenAccent],
    'lightGreen': [Colors.lightGreen, Colors.lightGreenAccent],
    'lime': [Colors.lime, Colors.limeAccent],
    'yellow': [Colors.yellow, Colors.yellowAccent],
    'amber': [Colors.amber, Colors.amberAccent],
    'orange': [Colors.orange, Colors.orangeAccent],
    'deepOrange': [Colors.deepOrange, Colors.deepOrangeAccent],
  };

  static ThemeData buildTheme(Brightness brightness, String color) {
    var baseColorScheme = brightness == Brightness.light ? ColorScheme.light() : ColorScheme.dark();
    var colorScheme = ColorScheme.fromSwatch(
      primarySwatch: colors[color]!.first,
      accentColor: colors[color]!.last,
      brightness: brightness,
      backgroundColor: brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
    ).copyWith(
      surface: brightness == Brightness.dark ? Colors.grey[850] : baseColorScheme.surface,
    );
    var themeData = ThemeData.from(colorScheme: colorScheme);
    return themeData.copyWith(
      toggleableActiveColor: colorScheme.primary,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: themeData.hintColor,
        ),
        shadowColor: Colors.black45,
        color: colorScheme.surface,
        textTheme: TextTheme(
          headline6: TextStyle().copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: themeData.hintColor,
          ),
        ),
        brightness: ThemeData.estimateBrightnessForColor(colorScheme.surface),
      ),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 0.0, color: Colors.transparent),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withAlpha(192),
      ),
      // platform: TargetPlatform.iOS,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  static Widget routeWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: child,
    );
  }
}

// darkTheme: ThemeData.dark().copyWith(
//   accentColor: Colors.deepPurpleAccent,
//   primaryColor: Colors.deepPurple,
// ),
// darkTheme: ThemeData.from(
//   colorScheme: ColorScheme.dark().copyWith(
//     primary: Colors.pink[200]!,
//     primaryVariant: Colors.pink[200]!,
//     secondary: Colors.pink[200]!,
//     secondaryVariant: Colors.pink[200]!,
//   ),
// ).copyWith(
//   platform: TargetPlatform.fuchsia,
//   toggleableActiveColor: Colors.pink[200]!,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: ColorScheme.dark().surface,
//     foregroundColor: Colors.pink[200]!,
//   ),
// ),
// theme: ThemeData.from(
//   colorScheme: ColorScheme.light().copyWith(
//     primary: Colors.pink[300]!,
//     primaryVariant: Colors.pink[300]!,
//     secondary: Colors.pink[300]!,
//     secondaryVariant: Colors.pink[300]!,
//   ),
// ).copyWith(
//   platform: TargetPlatform.fuchsia,
//   toggleableActiveColor: Colors.pink[300]!,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: ColorScheme.light().surface,
//     foregroundColor: Colors.pink[300]!,
//   ),
// ),
