import 'package:flutter/material.dart';
import 'package:flutter_material_next/ThemeManager.dart';
import '/MVP/Presenters/ThemePresenter.dart';
import 'package:flutter_material_next/ThemeableMaterialApp.dart';

import '../../App.dart';

/// [ThemeView] is our settings view that allows to change settings related to the theme. It uses the [ThemePresenter] to fetch and save a [ThemeModel] model that contains our configuration.
class ThemeView extends StatefulWidget {
  @override
  _ThemeViewState createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: ThemePresenter.loadData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                buildColorWidget(snapshot),
                buildModeWidget(snapshot),
              ],
            );
          }
          return CircularProgressIndicator.adaptive();
        },
      );

  Widget buildColorWidget(dynamic snapshot) => InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Ink(
                width: 256,
                height: 256,
                child: Material(
                  child: GridView.extent(
                    maxCrossAxisExtent: 64.0,
                    children: [
                      for (var color in Colors.primaries)
                        InkWell(
                          onTap: () async {
                            snapshot.data.color.first = color[300];
                            snapshot.data.color.last = color[200];
                            ThemeManager.of(context)!.lightColors.accent = snapshot.data.color.first;
                            ThemeManager.of(context)!.darkColors.accent = snapshot.data.color.last;
                            ThemePresenter.saveData(snapshot.data);
                            ThemeableMaterialApp.rebuild(context);
                            setState(() {});
                          },
                          child: Ink(
                            color: color,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Text('Color'),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: Container(
                    width: 32.0,
                    height: 32.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'Change the primary color of the application',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).iconTheme.color,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildModeWidget(dynamic snapshot) => InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      child: InkWell(
                        onTap: () async {
                          snapshot.data.themeMode = ThemeMode.system;
                          ThemeManager.of(context)!.mode = snapshot.data.themeMode;
                          ThemePresenter.saveData(snapshot.data);
                          ThemeableMaterialApp.rebuild(context);
                          setState(() {});
                          await Future.delayed(Duration(seconds: 2));
                          ThemeableMaterialApp.rebuild(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('System Theme'),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: InkWell(
                        onTap: () async {
                          snapshot.data.themeMode = ThemeMode.light;
                          ThemeManager.of(context)!.mode = snapshot.data.themeMode;
                          ThemePresenter.saveData(snapshot.data);
                          ThemeableMaterialApp.rebuild(context);
                          setState(() {});
                          await Future.delayed(Duration(seconds: 2));
                          ThemeableMaterialApp.rebuild(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Light Theme'),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: InkWell(
                        onTap: () async {
                          snapshot.data.themeMode = ThemeMode.dark;
                          ThemeManager.of(context)!.mode = snapshot.data.themeMode;
                          ThemePresenter.saveData(snapshot.data);
                          ThemeableMaterialApp.rebuild(context);
                          setState(() {});
                          await Future.delayed(Duration(seconds: 2));
                          ThemeableMaterialApp.rebuild(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Dark Theme'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  child: Center(
                    child: Icon(Icons.color_lens),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'Select the primary style of the theme',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).iconTheme.color,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
