import 'package:flutter/material.dart';

import 'ThemeManager.dart';

class ThemeableMaterialApp extends StatefulWidget {
  final List<Color> colors;
  final ThemeMode themeMode;
  final Function(BuildContext context, ThemeData darkTheme, ThemeData lightTheme, ThemeMode themeMode) appBuilder;

  const ThemeableMaterialApp({
    Key? key,
    required this.appBuilder,
    required this.colors,
    required this.themeMode,
  }) : super(key: key);

  @override
  _ThemeableMaterialAppState createState() => _ThemeableMaterialAppState();

  // ignore: invalid_use_of_protected_member
  static void rebuild(BuildContext context) => of(context)!.setState(() {});
  static _ThemeableMaterialAppState? of(BuildContext context) => context.findAncestorStateOfType<_ThemeableMaterialAppState>();
}

class _ThemeableMaterialAppState extends State<ThemeableMaterialApp> {
  @override
  Widget build(BuildContext context) => ThemeManager(
        colors: widget.colors,
        themeMode: widget.themeMode,
        child: Builder(
          builder: (context) => widget.appBuilder(context, ThemeManager.of(context)!.dark(), ThemeManager.of(context)!.light(), ThemeManager.of(context)!.themeMode),
        ),
      );
}
