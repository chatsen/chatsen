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
    on<ThemeInitialized>((event, emit) {
      var themeMode = themeBox.get('themeMode');
      var themeColorScheme = themeBox.get('themeColorScheme');
      var themeHighContrast = themeBox.get('themeHighContrast');
      emit(ThemeLoaded(
        mode: themeMode != null ? ThemeMode.values[themeMode] : mode,
        highContrast: themeHighContrast ?? false,
        colorScheme: themeColorScheme ?? colorScheme,
      ));
    });
    on<ThemeModeChanged>((event, emit) async {
      if (state is ThemeLoaded) {
        var previousState = state as ThemeLoaded;
        await themeBox.put('themeMode', event.mode.index);
        emit(previousState.copyWith(mode: event.mode));
      }
    });
    on<ThemeColorSchemeChanged>((event, emit) async {
      if (state is ThemeLoaded) {
        var previousState = state as ThemeLoaded;
        await themeBox.put('themeColorScheme', event.colorScheme);
        emit(previousState.copyWith(colorScheme: event.colorScheme));
      }
    });
    on<ThemeHighContrastChanged>((event, emit) async {
      if (state is ThemeLoaded) {
        var previousState = state as ThemeLoaded;
        await themeBox.put('themeHighContrast', event.highContrast);
        emit(previousState.copyWith(highContrast: event.highContrast));
      }
    });
    add(ThemeInitialized());
  }
}
