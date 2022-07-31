import 'package:chatsen/components/tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApplicationThemeModal extends StatelessWidget {
  const ApplicationThemeModal({super.key});

  static const Map<String, Color> colors = {
    'redAccent': Colors.redAccent,
    'red': Colors.red,
    'pinkAccent': Colors.pinkAccent,
    'pink': Colors.pink,
    'purpleAccent': Colors.purpleAccent,
    'purple': Colors.purple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'deepPurple': Colors.deepPurple,
    'indigoAccent': Colors.indigoAccent,
    'indigo': Colors.indigo,
    'blueAccent': Colors.blueAccent,
    'blue': Colors.blue,
    'lightBlueAccent': Colors.lightBlueAccent,
    'lightBlue': Colors.lightBlue,
    'cyanAccent': Colors.cyanAccent,
    'cyan': Colors.cyan,
    'tealAccent': Colors.tealAccent,
    'teal': Colors.teal,
    'greenAccent': Colors.greenAccent,
    'green': Colors.green,
    'lightGreenAccent': Colors.lightGreenAccent,
    'lightGreen': Colors.lightGreen,
    'limeAccent': Colors.limeAccent,
    'lime': Colors.lime,
    'yellowAccent': Colors.yellowAccent,
    'yellow': Colors.yellow,
    'amberAccent': Colors.amberAccent,
    'amber': Colors.amber,
    'orangeAccent': Colors.orangeAccent,
    'orange': Colors.orange,
    'deepOrangeAccent': Colors.deepOrangeAccent,
    'deepOrange': Colors.deepOrange,
    'brown': Colors.brown,
    'blueGrey': Colors.blueGrey,
  };

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          for (final color in colors.entries)
            Builder(builder: (context) {
              // final theme = M3Parser.patchTheme(
              //   ThemeData(
              //     colorSchemeSeed: color.value,
              //     brightness: Theme.of(context).brightness,
              //   ),
              // );
              return Tile(
                prefix: Material(
                  color: color.value,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                title: color.key,
                onTap: () async {
                  Navigator.pop(context);
                  await Hive.box('Settings').put('themeColor', color.value.value);
                },
              );
            }),
        ],
      );
}
