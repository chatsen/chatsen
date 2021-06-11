import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'ThemeEvent.dart';
import 'ThemeState.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeMode mode;
  final String colorScheme;
  final Box themeBox;

  ThemeBloc(
    this.themeBox, {
    this.mode = ThemeMode.system,
    this.colorScheme = 'amber',
  }) : super(ThemeLoading()) {
    add(ThemeInitialized());
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeInitialized) {
      var themeMode = themeBox.get('themeMode');
      var themeColorScheme = themeBox.get('themeColorScheme');
      yield ThemeLoaded(
        mode: themeMode != null ? ThemeMode.values[themeMode] : mode,
        colorScheme: themeColorScheme ?? colorScheme,
      );
    } else if (event is ThemeModeChanged && state is ThemeLoaded) {
      var previousState = state as ThemeLoaded;
      await themeBox.put('themeMode', event.mode.index);
      yield previousState.copyWith(mode: event.mode);
    } else if (event is ThemeColorSchemeChanged && state is ThemeLoaded) {
      var previousState = state as ThemeLoaded;
      await themeBox.put('themeColorScheme', event.colorScheme);
      yield previousState.copyWith(colorScheme: event.colorScheme);
    }
  }
}
