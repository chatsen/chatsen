import 'dart:io';

// import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows) {
  //   await Window.initialize();
  //   await Window.setEffect(
  //     effect: WindowEffect.mica,
  //     dark: true,
  //   );
  // }
  runApp(const App());
}
