import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatsen/Pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  ThemeData buildThemeData() {
    // theme: ThemeData.from(
    //       colorScheme: ColorScheme.highContrastDark(),
    //     ).copyWith(
    //       textTheme:
    //     ),
    var themeData = ThemeData.from(
      colorScheme: ColorScheme.dark(),
    );
    themeData = themeData.copyWith(
      // textTheme: GoogleFonts.latoTextTheme(themeData.textTheme),
      textTheme: GoogleFonts.openSansTextTheme(themeData.textTheme),
    );
    // Window.setEffect(
    //   effect: WindowEffect.mica,
    //   dark: themeData.brightness == Brightness.dark,
    // );
    return themeData;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        // theme: ThemeData(fontFamily: 'Raleway'),
        // theme: ThemeData.dark(),
        theme: buildThemeData(),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      );
}
