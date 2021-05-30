import 'package:flutter/material.dart';
import '/MVP/Views/ThemeView.dart';

/// [ThemeSettingsPage] is the Page scaffold representing our app's theme settings. It allows changing between Light/Dark/System theme mode and the accent color.
class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Theme Settings'),
        ),
        body: ThemeView(),
      );
}
