import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode mode;
  final bool highContrast;
  final String colorScheme;

  const ThemeLoaded({
    required this.mode,
    required this.highContrast,
    required this.colorScheme,
  }) : super();

  @override
  List<Object> get props => [mode, highContrast, colorScheme];

  ThemeLoaded copyWith({
    ThemeMode? mode,
    bool? highContrast,
    String? colorScheme,
  }) =>
      ThemeLoaded(
        mode: mode ?? this.mode,
        highContrast: highContrast ?? this.highContrast,
        colorScheme: colorScheme ?? this.colorScheme,
      );
}
