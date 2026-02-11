import 'dart:convert';

import 'package:hive/hive.dart';

import 'Accounts/AccountModel.dart';
import 'Commands/Command.dart';
import 'Mentions/CustomMention.dart';

Map<String, dynamic> buildExportData({
  required Box settingsBox,
  required Box themeBox,
  required Box accountsBox,
  required Box commandsBox,
  required Box customMentionsBox,
  required Box blockedUsersBox,
}) {
  return {
    'settings': {
      'setupScreen': settingsBox.get('setupScreen') ?? true,
      'notificationOnWhisper': settingsBox.get('notificationOnWhisper') ?? false,
      'notificationOnMention': settingsBox.get('notificationOnMention') ?? false,
      'notificationBackground': settingsBox.get('notificationBackground') ?? false,
      'mentionCustom': settingsBox.get('mentionCustom') ?? <String>[],
      'messageTimestamp': settingsBox.get('messageTimestamp') ?? false,
      'messageImagePreview': settingsBox.get('messageImagePreview') ?? false,
      'messageLines': settingsBox.get('messageLines') ?? false,
      'messageAlternateBackground': settingsBox.get('messageAlternateBackground') ?? false,
      'historyUseRecentMessages': settingsBox.get('historyUseRecentMessages') ?? true,
      'mentionWithAt': settingsBox.get('mentionWithAt') ?? false,
    },
    'theme': {
      'mode': themeBox.get('themeMode'),
      'colorScheme': themeBox.get('themeColorScheme'),
      'highContrast': themeBox.get('themeHighContrast') ?? false,
    },
    'accounts': [
      for (final account in accountsBox.values)
        if ((account as AccountModel).token != null)
          {
            'login': account.login,
            'token': account.token,
            'id': account.id,
            'clientId': account.clientId,
            'isActive': account.isActive,
          },
    ],
    'commands': [
      for (final command in commandsBox.values)
        {
          'trigger': (command as Command).trigger,
          'command': command.command,
        },
    ],
    'customMentions': [
      for (final mention in customMentionsBox.values)
        {
          'pattern': (mention as CustomMention).pattern,
          'showInMentions': mention.showInMentions,
          'sendNotification': mention.sendNotification,
          'playSound': mention.playSound,
          'enableRegex': mention.enableRegex,
          'caseSensitive': mention.caseSensitive,
        },
    ],
    'blockedUsers': List<String>.from(blockedUsersBox.values),
  };
}

String buildExportJson({
  required Box settingsBox,
  required Box themeBox,
  required Box accountsBox,
  required Box commandsBox,
  required Box customMentionsBox,
  required Box blockedUsersBox,
}) {
  return const JsonEncoder.withIndent('  ').convert(buildExportData(
    settingsBox: settingsBox,
    themeBox: themeBox,
    accountsBox: accountsBox,
    commandsBox: commandsBox,
    customMentionsBox: customMentionsBox,
    blockedUsersBox: blockedUsersBox,
  ));
}
