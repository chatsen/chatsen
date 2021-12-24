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
  final bool notificationBackground;
  final List<String> mentionCustom;
  final bool messageTimestamp;
  final bool messageImagePreview;
  final bool messageLines;
  final bool messageAlternateBackground;
  final bool historyUseRecentMessages;
  final bool mentionWithAt;

  SettingsLoaded({
    required this.setupScreen,
    required this.notificationOnWhisper,
    required this.notificationOnMention,
    required this.notificationBackground,
    required this.mentionCustom,
    required this.messageTimestamp,
    required this.messageImagePreview,
    required this.messageLines,
    required this.messageAlternateBackground,
    required this.historyUseRecentMessages,
    required this.mentionWithAt,
  });

  SettingsLoaded copyWith({
    bool? setupScreen,
    bool? notificationOnWhisper,
    bool? notificationOnMention,
    bool? notificationBackground,
    List<String>? mentionCustom,
    bool? messageTimestamp,
    bool? messageImagePreview,
    bool? messageLines,
    bool? messageAlternateBackground,
    bool? historyUseRecentMessages,
    bool? mentionWithAt,
  }) {
    return SettingsLoaded(
      setupScreen: setupScreen ?? this.setupScreen,
      notificationOnWhisper: notificationOnWhisper ?? this.notificationOnWhisper,
      notificationOnMention: notificationOnMention ?? this.notificationOnMention,
      notificationBackground: notificationBackground ?? this.notificationBackground,
      mentionCustom: mentionCustom ?? this.mentionCustom,
      messageTimestamp: messageTimestamp ?? this.messageTimestamp,
      messageImagePreview: messageImagePreview ?? this.messageImagePreview,
      messageLines: messageLines ?? this.messageLines,
      messageAlternateBackground: messageAlternateBackground ?? this.messageAlternateBackground,
      historyUseRecentMessages: historyUseRecentMessages ?? this.historyUseRecentMessages,
      mentionWithAt: mentionWithAt ?? this.mentionWithAt,
    );
  }

  @override
  List<Object?> get props => [setupScreen, notificationOnWhisper, notificationOnMention, notificationBackground, mentionCustom, messageTimestamp, messageImagePreview, messageLines, messageAlternateBackground, historyUseRecentMessages, mentionWithAt, ...super.props];
}
