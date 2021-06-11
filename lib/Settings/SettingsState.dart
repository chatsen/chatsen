import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool setupScreen;
  final bool notificationOnWhisper;
  final bool notificationOnMention;
  final List<String> mentionCustom;
  final bool messageTimestamp;
  final bool messageImagePreview;
  final bool messageLines;
  final bool messageAlternateBackground;
  final bool historyUseRecentMessages;

  SettingsLoaded({
    required this.setupScreen,
    required this.notificationOnWhisper,
    required this.notificationOnMention,
    required this.mentionCustom,
    required this.messageTimestamp,
    required this.messageImagePreview,
    required this.messageLines,
    required this.messageAlternateBackground,
    required this.historyUseRecentMessages,
  });

  SettingsLoaded copyWith({
    bool? setupScreen,
    bool? notificationOnWhisper,
    bool? notificationOnMention,
    List<String>? mentionCustom,
    bool? messageTimestamp,
    bool? messageImagePreview,
    bool? messageLines,
    bool? messageAlternateBackground,
    bool? historyEnabled,
  }) {
    return SettingsLoaded(
      setupScreen: setupScreen ?? this.setupScreen,
      notificationOnWhisper: notificationOnWhisper ?? this.notificationOnWhisper,
      notificationOnMention: notificationOnMention ?? this.notificationOnMention,
      mentionCustom: mentionCustom ?? this.mentionCustom,
      messageTimestamp: messageTimestamp ?? this.messageTimestamp,
      messageImagePreview: messageImagePreview ?? this.messageImagePreview,
      messageLines: messageLines ?? this.messageLines,
      messageAlternateBackground: messageAlternateBackground ?? this.messageAlternateBackground,
      historyUseRecentMessages: historyEnabled ?? this.historyUseRecentMessages,
    );
  }

  @override
  List<Object?> get props => [setupScreen, notificationOnWhisper, notificationOnMention, mentionCustom, messageTimestamp, messageImagePreview, messageLines, messageAlternateBackground, historyUseRecentMessages, ...super.props];
}
