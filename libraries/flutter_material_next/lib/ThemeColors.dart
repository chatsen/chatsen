import 'package:flutter/material.dart';

class ThemeColors {
  Color accent;
  Color foregroundColor;
  Color backgroundColor;
  Color iconColor;

  ThemeColors({
    @required this.accent,
    @required this.foregroundColor,
    @required this.backgroundColor,
    @required this.iconColor,
  });

  ThemeColors.copyWith({
    Color accent,
    Color foregroundColor,
    Color backgroundColor,
    Color iconColor,
  })  : accent = accent,
        foregroundColor = foregroundColor,
        backgroundColor = backgroundColor,
        iconColor = iconColor;
}
