import 'package:flutter/material.dart';

/// The [ThemeModel] is a class that holds our data for the theme.
class ThemeModel {
  List<Color?>? color;
  ThemeMode themeMode;

  ThemeModel({
    this.color,
    this.themeMode = ThemeMode.system,
  }) {
    color = color ?? [Colors.red[300], Colors.red[200]];
  }
}
