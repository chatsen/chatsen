// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Logged in via $provider';
  }

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get expiresNever => 'कभी समाप्त नहीं';

  @override
  String expiresIn(String time) {
    return 'Expires in $time';
  }

  @override
  String get close => 'बंद करें';

  @override
  String get add => 'जोडें';

  @override
  String get cancel => 'कैंसिल';

  @override
  String get tokenInput => 'Token input';

  @override
  String get account => 'खाता';

  @override
  String get refreshAccount => 'खाते रिफ्रेश हो रहें हैं';

  @override
  String get removeAccount => 'खाता हटाएं';

  @override
  String get addAnotherAccount => 'एक और खाता जोड़ें';

  @override
  String get verifiedUserData => 'लोग इन डेटा को परखना';

  @override
  String loggedInAs(String user) {
    return 'Logged in as $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      'An error has occurred when verifying user data:';

  @override
  String get verifyingUserData => 'लोग इन डेटा को परखना';

  @override
  String get verifiedUserToken => 'लोग इन डेटा को परखना';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      'An error has occurred when verifying user token:';

  @override
  String get verifyingUserToken => 'लोग इन डेटा को परखना';

  @override
  String get searchForChannels => 'किसी चैनल को खोजें';

  @override
  String get recommendedChannels => 'अनुशंसित चैनल';

  @override
  String get popularChannels => 'लोकप्रिय लाइव चैनल';

  @override
  String get channel => 'चैनल्स';

  @override
  String get leaveChannel => 'चैनल छोड़ दें?';

  @override
  String joinUser(String user) {
    return '$user चैनल से जुड़े';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Spell check failed! Did you mean to search for $username?';
  }

  @override
  String joinChannelName(String channel) {
    return '$channel चैनल से जुड़े';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Send message in $channel';
  }

  @override
  String get light => 'लाइट';

  @override
  String get dark => 'डार्क';

  @override
  String get system => 'सिस्टम';

  @override
  String get appearance => 'स्वरूप';

  @override
  String get highContrast => 'जादा कॉन्ट्रास्ट';

  @override
  String get playStream => 'Play stream';

  @override
  String get stopStream => 'स्ट्रीम रोक दें?';

  @override
  String get customCommand => 'कस्टम कमांड्स';

  @override
  String get customCommands => 'कस्टम कमांड्स';

  @override
  String get newCustomCommand => 'New custom command';

  @override
  String get commandTrigger => 'Trigger';

  @override
  String get command => 'आदेश:';

  @override
  String get save => 'सेव करें';

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
