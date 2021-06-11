import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/Components/Notification.dart';
import 'Pages/Home.dart';
import 'Settings/Settings.dart';
import 'Settings/SettingsState.dart';
import 'Theme/ThemeBloc.dart';
import 'Theme/ThemeManager.dart';
import 'Theme/ThemeState.dart';

/// Our [App] class. It represents our MaterialApp and will redirect us to our app's homepage.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<Settings, SettingsState>(
        builder: (context, settingsState) => BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            if (themeState is ThemeLoaded && settingsState is SettingsLoaded) {
              return MaterialApp(
                darkTheme: ThemeManager.buildTheme(Brightness.dark, themeState.colorScheme),
                theme: ThemeManager.buildTheme(Brightness.light, themeState.colorScheme),
                themeMode: themeState.mode,
                debugShowCheckedModeBanner: false,
                home: NotificationWrapper(
                  child: Builder(
                    builder: (context) => ThemeManager.routeWrapper(
                      context: context,
                      child: HomePage(),
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      );
}
