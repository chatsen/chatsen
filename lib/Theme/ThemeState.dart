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
  final String colorScheme;

  const ThemeLoaded({
    required this.mode,
    required this.colorScheme,
  }) : super();

  @override
  List<Object> get props => [mode, colorScheme];

  ThemeLoaded copyWith({
    ThemeMode? mode,
    String? colorScheme,
  }) =>
      ThemeLoaded(
        mode: mode ?? this.mode,
        colorScheme: colorScheme ?? this.colorScheme,
      );
}
