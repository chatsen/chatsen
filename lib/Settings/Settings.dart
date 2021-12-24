import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import 'SettingsEvent.dart';
import 'SettingsState.dart';

class Settings extends Bloc<SettingsEvent, SettingsState> {
  final Box settingsBox;

  Settings(this.settingsBox) : super(SettingsLoading()) {
    add(SettingsLoad());
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsLoad) {
      yield SettingsLoaded(
        setupScreen: settingsBox.get('setupScreen') ?? true,
        notificationOnWhisper: settingsBox.get('notificationOnWhisper') ?? false,
        notificationOnMention: settingsBox.get('notificationOnMention') ?? false,
        notificationBackground: settingsBox.get('notificationBackground') ?? false,
        messageTimestamp: settingsBox.get('messageTimestamp') ?? false,
        messageImagePreview: settingsBox.get('messageImagePreview') ?? false,
        messageLines: settingsBox.get('messageLines') ?? false,
        messageAlternateBackground: settingsBox.get('messageAlternateBackground') ?? false,
        mentionCustom: settingsBox.get('mentionCustom') ?? [],
        historyUseRecentMessages: settingsBox.get('historyUseRecentMessages') ?? true,
        mentionWithAt: settingsBox.get('mentionWithAt') ?? false,
      );
    } else if (event is SettingsChange) {
      await settingsBox.put('setupScreen', event.state.setupScreen);
      await settingsBox.put('notificationOnWhisper', event.state.notificationOnWhisper);
      await settingsBox.put('notificationOnMention', event.state.notificationOnMention);
      await settingsBox.put('notificationBackground', event.state.notificationBackground);
      await settingsBox.put('messageTimestamp', event.state.messageTimestamp);
      await settingsBox.put('messageImagePreview', event.state.messageImagePreview);
      await settingsBox.put('messageLines', event.state.messageLines);
      await settingsBox.put('messageAlternateBackground', event.state.messageAlternateBackground);
      await settingsBox.put('mentionCustom', event.state.mentionCustom);
      await settingsBox.put('historyUseRecentMessages', event.state.historyUseRecentMessages);
      await settingsBox.put('mentionWithAt', event.state.mentionWithAt);
      yield event.state;
    }
  }
}
