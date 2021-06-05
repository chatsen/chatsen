import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_next/ThemeableMaterialApp.dart';

import '/Components/Notification.dart';
import '/MVP/Presenters/ThemePresenter.dart';
import '/Pages/Home.dart';
import '/MVP/Models/ThemeModel.dart';

/// Our [App] class. It represents our MaterialApp and will redirect us to our app's homepage.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      child: FutureBuilder<ThemeModel>(
        future: ThemePresenter.loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return MaterialApp(home: Scaffold());
          return ThemeableMaterialApp(
            appBuilder: (BuildContext context, ThemeData darkTheme, ThemeData lightTheme, ThemeMode themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                darkTheme: darkTheme,
                theme: lightTheme,
                home: Builder(
                  builder: (context) {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.transparent,
                      statusBarColor: Colors.white.withAlpha(0),
                      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
                    ));
                    return HomePage();
                  },
                ),
              );
            },
            colors: snapshot.data!.color!.map((x) => x!).toList(),
            themeMode: snapshot.data!.themeMode,
          );
        },
      ),
    );
  }
}
