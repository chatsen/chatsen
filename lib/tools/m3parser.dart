import 'dart:convert';

import 'package:flutter/material.dart';

class M3Parser {
  static Color parseColor(String? color) {
    return Color(int.tryParse('ff' + color!.substring(1), radix: 16) ?? 0);
  }

  static ThemeData parse(
    String themeData, {
    bool dark = false,
  }) {
    final jsonData = json.decode(themeData);
    var baseTheme = ThemeData.from(
      colorScheme: dark
          ? ColorScheme.dark(
              primary: parseColor(jsonData['dark']['primary']),
              onPrimary: parseColor(jsonData['dark']['onPrimary']),
              primaryContainer: parseColor(jsonData['dark']['primaryContainer']),
              onPrimaryContainer: parseColor(jsonData['dark']['onPrimaryContainer']),
              secondary: parseColor(jsonData['dark']['secondary']),
              onSecondary: parseColor(jsonData['dark']['onSecondary']),
              secondaryContainer: parseColor(jsonData['dark']['secondaryContainer']),
              onSecondaryContainer: parseColor(jsonData['dark']['onSecondaryContainer']),
              tertiary: parseColor(jsonData['dark']['tertiary']),
              onTertiary: parseColor(jsonData['dark']['onTertiary']),
              tertiaryContainer: parseColor(jsonData['dark']['tertiaryContainer']),
              onTertiaryContainer: parseColor(jsonData['dark']['onTertiaryContainer']),
              error: parseColor(jsonData['dark']['error']),
              errorContainer: parseColor(jsonData['dark']['errorContainer']),
              onError: parseColor(jsonData['dark']['onError']),
              onErrorContainer: parseColor(jsonData['dark']['onErrorContainer']),
              background: parseColor(jsonData['dark']['background']),
              onBackground: parseColor(jsonData['dark']['onBackground']),
              surface: parseColor(jsonData['dark']['surface']),
              onSurface: parseColor(jsonData['dark']['onSurface']),
              surfaceVariant: parseColor(jsonData['dark']['surfaceVariant']),
              onSurfaceVariant: parseColor(jsonData['dark']['onSurfaceVariant']),
              outline: parseColor(jsonData['dark']['outline']),
              onInverseSurface: parseColor(jsonData['dark']['inverseOnSurface']),
              inverseSurface: parseColor(jsonData['dark']['inverseSurface']),
            )
          : ColorScheme.light(
              primary: parseColor(jsonData['light']['primary']),
              onPrimary: parseColor(jsonData['light']['onPrimary']),
              primaryContainer: parseColor(jsonData['light']['primaryContainer']),
              onPrimaryContainer: parseColor(jsonData['light']['onPrimaryContainer']),
              secondary: parseColor(jsonData['light']['secondary']),
              onSecondary: parseColor(jsonData['light']['onSecondary']),
              secondaryContainer: parseColor(jsonData['light']['secondaryContainer']),
              onSecondaryContainer: parseColor(jsonData['light']['onSecondaryContainer']),
              tertiary: parseColor(jsonData['light']['tertiary']),
              onTertiary: parseColor(jsonData['light']['onTertiary']),
              tertiaryContainer: parseColor(jsonData['light']['tertiaryContainer']),
              onTertiaryContainer: parseColor(jsonData['light']['onTertiaryContainer']),
              error: parseColor(jsonData['light']['error']),
              errorContainer: parseColor(jsonData['light']['errorContainer']),
              onError: parseColor(jsonData['light']['onError']),
              onErrorContainer: parseColor(jsonData['light']['onErrorContainer']),
              background: parseColor(jsonData['light']['background']),
              onBackground: parseColor(jsonData['light']['onBackground']),
              surface: parseColor(jsonData['light']['surface']),
              onSurface: parseColor(jsonData['light']['onSurface']),
              surfaceVariant: parseColor(jsonData['light']['surfaceVariant']),
              onSurfaceVariant: parseColor(jsonData['light']['onSurfaceVariant']),
              outline: parseColor(jsonData['light']['outline']),
              onInverseSurface: parseColor(jsonData['light']['inverseOnSurface']),
              inverseSurface: parseColor(jsonData['light']['inverseSurface']),
            ),
    );

    final newThemeData = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: 'ProductSans',
        bodyColor: baseTheme.colorScheme.onBackground,
        displayColor: baseTheme.colorScheme.onBackground,
        decorationColor: baseTheme.colorScheme.onBackground,
      ),
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: baseTheme.colorScheme.onPrimaryContainer.withOpacity(0.0),
            // width: 2,
            width: 0,
          ),
        ),
        labelColor: baseTheme.colorScheme.onPrimaryContainer,
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        hintStyle: (baseTheme.inputDecorationTheme.hintStyle ?? const TextStyle()).copyWith(
          color: baseTheme.colorScheme.onPrimaryContainer.withOpacity(0.75),
        ),
      ),
      useMaterial3: true,
    );
    return newThemeData;
  }
}
