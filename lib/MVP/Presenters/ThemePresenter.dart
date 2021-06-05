import 'package:flutter/material.dart';
import '/MVP/Models/ThemeModel.dart';
import 'package:hive/hive.dart';

/// [ThemePresenter] is the presenter used for our theme settings. It saves and loads in a [ThemeModel] model.
class ThemePresenter {
  static Future<ThemeModel> loadData() async {
    var box = await Hive.openBox('Settings');
    var themeMode = ThemeMode.values[box.containsKey('ThemeMode') ? box.get('ThemeMode') : ThemeMode.system.index];
    var themeColorLight = box.containsKey('ThemeColorLight') ? box.get('ThemeColorLight') : Colors.red[300]!.value;
    var themeColorDark = box.containsKey('ThemeColorDark') ? box.get('ThemeColorDark') : Colors.red[200]!.value;
    return ThemeModel(
      themeMode: themeMode,
      color: [Color(themeColorLight), Color(themeColorDark)],
    );
  }

  static void saveData(ThemeModel themeModel) async {
    var box = Hive.box('Settings');
    await box.put('ThemeMode', themeModel.themeMode.index);
    await box.put('ThemeColorLight', themeModel.color!.first!.value);
    await box.put('ThemeColorDark', themeModel.color!.last!.value);
  }
}
