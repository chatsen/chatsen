// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get chatsen => 'צ\'אטסן';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'מחובר דרך $provider';
  }

  @override
  String get termsOfService => 'תנאי השירות';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get settings => 'הגדרות';

  @override
  String get expiresNever => 'לעולם לא יפוג';

  @override
  String expiresIn(String time) {
    return 'פג תוקף ב-$time';
  }

  @override
  String get close => 'סגור';

  @override
  String get add => 'הוסף';

  @override
  String get cancel => 'ביטול';

  @override
  String get tokenInput => 'טוקן';

  @override
  String get account => 'חשבון';

  @override
  String get refreshAccount => 'רענן חשבון';

  @override
  String get removeAccount => 'הסר חשבון';

  @override
  String get addAnotherAccount => 'הוסף חשבון נוסף';

  @override
  String get verifiedUserData => 'נתוני משתמש מאומתים!';

  @override
  String loggedInAs(String user) {
    return 'מחובר כ$user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      'שגיאה בעת אימות נתוני משתמש:';

  @override
  String get verifyingUserData => 'מאמת את נתוני המשתמש...';

  @override
  String get verifiedUserToken => 'טוקן משתמש מאומת!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      'שגיאה בעת אימות טוקן משתמש:';

  @override
  String get verifyingUserToken => 'מאמת טוקן משתמש...';

  @override
  String get searchForChannels => 'חפש ערוצים';

  @override
  String get recommendedChannels => 'ערוצים מומלצים';

  @override
  String get popularChannels => 'ערוצים פופולרים';

  @override
  String get channel => 'ערוץ';

  @override
  String get leaveChannel => 'עזוב ערוץ';

  @override
  String joinUser(String user) {
    return 'הצטרף ל-$user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'בדיקת האיות נכשלה! האם התכוונת לחפש את $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'הצטרף ל-$channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'שלח הודעה ב-$channel';
  }

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get appearance => 'Appearance';

  @override
  String get highContrast => 'High contrast';

  @override
  String get playStream => 'Play stream';

  @override
  String get stopStream => 'Stop stream';

  @override
  String get customCommand => 'Custom command';

  @override
  String get customCommands => 'Custom commands';

  @override
  String get newCustomCommand => 'New custom command';

  @override
  String get commandTrigger => 'Trigger';

  @override
  String get command => 'Command';

  @override
  String get save => 'Save';

  @override
  String get browserStreamSettings => 'Browser/Stream Settings';

  @override
  String get addPage => 'Add page';

  @override
  String channelStream(String channel) {
    return '$channel\'s stream';
  }

  @override
  String get openInBrowser => 'Open in browser';

  @override
  String get messageAppearance => 'Message appearance';

  @override
  String get showTimestamps => 'Show timestamps';

  @override
  String get compactMessages => 'Compact messages';

  @override
  String get messageTrigger => 'Message trigger';

  @override
  String get pattern => 'Pattern';

  @override
  String get mention => 'Mention';

  @override
  String get block => 'Block';

  @override
  String get enableRegex => 'Enable regex';

  @override
  String get caseSensitive => 'Case sensitive';

  @override
  String get messageTriggers => 'Message triggers';

  @override
  String get newMessageTrigger => 'New message trigger';

  @override
  String get reply => 'Reply';

  @override
  String get copyText => 'Copy text';

  @override
  String get copyTextSubtitle => 'Hold to copy message text with username';

  @override
  String get deleteMessage => 'Delete message';

  @override
  String get mentionUser => 'Mention user';

  @override
  String get copyMessageId => 'Copy message ID';

  @override
  String get theme => 'Theme';

  @override
  String get userTrigger => 'User trigger';

  @override
  String get userTriggers => 'User triggers';

  @override
  String get chatHistory => 'Chat history';

  @override
  String get login => 'Login';

  @override
  String get newUserTrigger => 'New user trigger';

  @override
  String get ban => 'Ban';

  @override
  String get unban => 'Unban';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Timeout user for $duration';
  }

  @override
  String get chatCleared => 'Chat was cleared';

  @override
  String get permabanned => 'permabanned';

  @override
  String bannedForDuration(String duration) {
    return 'banned for $duration';
  }

  @override
  String get replyingTo => 'Replying to';

  @override
  String get blockedMessage => 'Blocked message';

  @override
  String get showMessage => 'Show message';

  @override
  String get hideMessage => 'Hide message';

  @override
  String get scrollToBottom => 'Scroll to bottom';

  @override
  String get startUsingTheApp =>
      'To start using the app, add an account below.';

  @override
  String get chatSettings => 'Chat settings';

  @override
  String get autocompleteUsersWithAt => 'Autocomplete users with @';

  @override
  String get autocompleteEmotesWithColon => 'Autocomplete emotes with :';

  @override
  String get language => 'Language';

  @override
  String get locale => 'Locale';

  @override
  String get systemDefault => 'System default';

  @override
  String get justDefault => 'Default';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Someone, somewhere, will mention you someday.';

  @override
  String get backgroundNotifications => 'Background notifications';

  @override
  String get optionNotAvailableOnYourPlatform =>
      'This option is not available on your platform.';

  @override
  String get optionNotAvailablePaywalled =>
      'This option is for Chatsen supporters only.';

  @override
  String get clearAll => 'Clear all';

  @override
  String get cache => 'Cache';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get chatters => 'Chatters';

  @override
  String lastSeenAgo(String time) {
    return 'Last seen $time ago';
  }

  @override
  String get credits => 'Credits';

  @override
  String get search => 'Search';
}
