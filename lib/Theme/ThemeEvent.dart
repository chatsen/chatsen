import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeInitialized extends ThemeEvent {}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode mode;

  const ThemeModeChanged({
    required this.mode,
  }) : super();

  @override
  List<Object> get props => [mode];
}

class ThemeColorSchemeChanged extends ThemeEvent {
  final String colorScheme;

  const ThemeColorSchemeChanged({
    required this.colorScheme,
  }) : super();

  @override
  List<Object> get props => [colorScheme];
}
