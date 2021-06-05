import 'package:flutter/material.dart';

import 'ThemeColors.dart';
import 'ThemeableMaterialApp.dart';

class ThemeManager extends StatefulWidget {
  final List<Color> colors;
  final ThemeMode themeMode;
  final Widget child;

  const ThemeManager({
    Key? key,
    required this.child,
    required this.colors,
    required this.themeMode,
  }) : super(key: key);

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState? of(BuildContext context) => context.findAncestorStateOfType<ThemeManagerState>();
}

class ThemeManagerState extends State<ThemeManager> {
  ThemeMode themeMode = ThemeMode.dark;

  ThemeColors lightColors = ThemeColors(
    accent: Colors.red[300],
    backgroundColor: Colors.grey[50],
    foregroundColor: Colors.grey[50],
    iconColor: Colors.grey[600],
  );

  ThemeColors darkColors = ThemeColors(
    accent: Colors.red[200],
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.grey[850],
    iconColor: Colors.grey[500],
  );

  ThemeMode get mode => themeMode;
  set mode(ThemeMode mode) => ThemeableMaterialApp.of(context)!.setState(() => themeMode = mode);

  @override
  void initState() {
    themeMode = widget.themeMode;
    lightColors.accent = widget.colors.first;
    darkColors.accent = widget.colors.last;
    super.initState();
  }

  ThemeData theme(ThemeData baseTheme, ThemeColors themeColors) {
    return baseTheme.copyWith(
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      primaryColor: themeColors.accent,
      backgroundColor: themeColors.iconColor!.withAlpha(128),
      accentColor: themeColors.accent,
      textSelectionTheme: (baseTheme.textSelectionTheme ?? TextSelectionThemeData()).copyWith(
        cursorColor: themeColors.accent,
        selectionColor: themeColors.accent,
        selectionHandleColor: themeColors.accent,
      ),
      sliderTheme: SliderThemeData.fromPrimaryColors(
        primaryColor: themeColors.accent!,
        primaryColorDark: themeColors.accent!,
        primaryColorLight: themeColors.accent!,
        valueIndicatorTextStyle: baseTheme.sliderTheme.valueIndicatorTextStyle ?? TextStyle(),
      ),
      toggleableActiveColor: themeColors.accent,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: themeColors.accent,
        secondary: themeColors.foregroundColor,
        onSecondary: themeColors.accent,
      ),
      scaffoldBackgroundColor: themeColors.backgroundColor,
      canvasColor: themeColors.foregroundColor,
      cardColor: themeColors.foregroundColor,
      cardTheme: CardTheme(
        color: themeColors.foregroundColor,
      ),
      indicatorColor: themeColors.accent,
      buttonTheme: (baseTheme.buttonTheme ?? ButtonThemeData()).copyWith(
        buttonColor: themeColors.accent,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        textTheme: ButtonTextTheme.primary,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: themeColors.accent,
          secondary: themeColors.foregroundColor,
          onSecondary: themeColors.accent,
          brightness: Brightness.light,
        ),
      ),
      tabBarTheme: (baseTheme.tabBarTheme ?? TabBarTheme()).copyWith(
        labelColor: themeColors.accent,
        unselectedLabelColor: themeColors.iconColor,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        color: themeColors.backgroundColor,
        elevation: 1.0,
        iconTheme: (baseTheme.appBarTheme.iconTheme ?? IconThemeData()).copyWith(
          color: themeColors.iconColor,
        ),
      ),
      iconTheme: (baseTheme.iconTheme ?? IconThemeData()).copyWith(
        color: themeColors.iconColor,
      ),
      primaryTextTheme: (baseTheme.appBarTheme.textTheme ?? baseTheme.primaryTextTheme ?? TextTheme()).copyWith(
        headline6: (baseTheme.appBarTheme.textTheme ?? baseTheme.primaryTextTheme ?? TextTheme()).headline6!.copyWith(
              color: themeColors.iconColor,
            ),
      ),
    );
  }

  ThemeData light() {
    return theme(ThemeData.light(), lightColors);
  }

  ThemeData dark() {
    return theme(ThemeData.dark(), darkColors);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
