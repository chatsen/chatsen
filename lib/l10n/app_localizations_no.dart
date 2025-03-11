// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Logget inn som $provider';
  }

  @override
  String get termsOfService => 'Vilkår for Bruk';

  @override
  String get privacyPolicy => 'Personvernerklæring';

  @override
  String get settings => 'Innstillinger';

  @override
  String get expiresNever => 'Utgår aldri';

  @override
  String expiresIn(String time) {
    return 'Utgår om $time';
  }

  @override
  String get close => 'Lukk';

  @override
  String get add => 'Legg til';

  @override
  String get cancel => 'Avbryt';

  @override
  String get tokenInput => 'Tast inn token';

  @override
  String get account => 'Profil';

  @override
  String get refreshAccount => 'Last inn profil på nytt';

  @override
  String get removeAccount => 'Fjern bruker';

  @override
  String get addAnotherAccount => 'Legg til bruker';

  @override
  String get verifiedUserData => 'Verifisert bruker data!';

  @override
  String loggedInAs(String user) {
    return 'Logget inn som $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Det oppsto en feil med verifisering av bruker data:';

  @override
  String get verifyingUserData => 'Verifiserer bruker data...';

  @override
  String get verifiedUserToken => 'Verifisert bruker token!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Det oppsto en feil med verifisering av bruker token:';

  @override
  String get verifyingUserToken => 'Verifiserer bruker token...';

  @override
  String get searchForChannels => 'Søk for kanaler';

  @override
  String get recommendedChannels => 'Anbefalte kanaler';

  @override
  String get popularChannels => 'Populære kanaler';

  @override
  String get channel => 'Channel';

  @override
  String get leaveChannel => 'Leave channel';

  @override
  String joinUser(String user) {
    return 'Join $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Spell check failed! Did you mean to search for $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Join $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Send message in $channel';
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
  String get startUsingTheApp => 'To start using the app, add an account below.';

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
  String get optionNotAvailableOnYourPlatform => 'This option is not available on your platform.';

  @override
  String get optionNotAvailablePaywalled => 'This option is for Chatsen supporters only.';

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
