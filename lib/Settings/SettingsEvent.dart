import 'package:equatable/equatable.dart';

import 'SettingsState.dart';

class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsLoad extends SettingsEvent {}

class SettingsChange extends SettingsEvent {
  final SettingsLoaded state;

  SettingsChange({
    required this.state,
  });

  @override
  List<Object?> get props => [state, ...super.props];
}
