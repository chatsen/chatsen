import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en', 'CA'),
    Locale('en', 'PT'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sr'),
    Locale('sv'),
    Locale('tr'),
    Locale('vi')
  ];

  /// No description provided for @chatsen.
  ///
  /// In en, this message translates to:
  /// **'Chatsen'**
  String get chatsen;

  /// No description provided for @catsen.
  ///
  /// In en, this message translates to:
  /// **'Catsen'**
  String get catsen;

  /// Translators should put their desired names to be displayed in the application credits, separated by semicolons here. Example: forsen;nymn;randomuser123 (one per contributor)
  ///
  /// In en, this message translates to:
  /// **''**
  String get translationAuthorNames;

  /// No description provided for @loggedInVia.
  ///
  /// In en, this message translates to:
  /// **'Logged in via {provider}'**
  String loggedInVia(String provider);

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @expiresNever.
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get expiresNever;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {time}'**
  String expiresIn(String time);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tokenInput.
  ///
  /// In en, this message translates to:
  /// **'Token input'**
  String get tokenInput;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @refreshAccount.
  ///
  /// In en, this message translates to:
  /// **'Refresh account'**
  String get refreshAccount;

  /// No description provided for @removeAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get removeAccount;

  /// No description provided for @addAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'Add another account'**
  String get addAnotherAccount;

  /// No description provided for @verifiedUserData.
  ///
  /// In en, this message translates to:
  /// **'Verified user data!'**
  String get verifiedUserData;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as {user}'**
  String loggedInAs(String user);

  /// No description provided for @anErrorHasOccuredWhenVerifyingUserData.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred when verifying user data:'**
  String get anErrorHasOccuredWhenVerifyingUserData;

  /// No description provided for @verifyingUserData.
  ///
  /// In en, this message translates to:
  /// **'Verifying user data...'**
  String get verifyingUserData;

  /// No description provided for @verifiedUserToken.
  ///
  /// In en, this message translates to:
  /// **'Verified user token!'**
  String get verifiedUserToken;

  /// No description provided for @anErrorHasOccuredWhenVerifyingUserToken.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred when verifying user token:'**
  String get anErrorHasOccuredWhenVerifyingUserToken;

  /// No description provided for @verifyingUserToken.
  ///
  /// In en, this message translates to:
  /// **'Verifying user token...'**
  String get verifyingUserToken;

  /// No description provided for @searchForChannels.
  ///
  /// In en, this message translates to:
  /// **'Search for channels'**
  String get searchForChannels;

  /// No description provided for @recommendedChannels.
  ///
  /// In en, this message translates to:
  /// **'Recommended channels'**
  String get recommendedChannels;

  /// No description provided for @popularChannels.
  ///
  /// In en, this message translates to:
  /// **'Popular channels'**
  String get popularChannels;

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @leaveChannel.
  ///
  /// In en, this message translates to:
  /// **'Leave channel'**
  String get leaveChannel;

  /// No description provided for @joinUser.
  ///
  /// In en, this message translates to:
  /// **'Join {user}'**
  String joinUser(String user);

  /// No description provided for @spellCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Spell check failed! Did you mean to search for {username}?'**
  String spellCheckFailed(String username);

  /// No description provided for @joinChannelName.
  ///
  /// In en, this message translates to:
  /// **'Join {channel}'**
  String joinChannelName(String channel);

  /// No description provided for @sendMessageIn.
  ///
  /// In en, this message translates to:
  /// **'Send message in {channel}'**
  String sendMessageIn(String channel);

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @playStream.
  ///
  /// In en, this message translates to:
  /// **'Play stream'**
  String get playStream;

  /// No description provided for @stopStream.
  ///
  /// In en, this message translates to:
  /// **'Stop stream'**
  String get stopStream;

  /// No description provided for @customCommand.
  ///
  /// In en, this message translates to:
  /// **'Custom command'**
  String get customCommand;

  /// No description provided for @customCommands.
  ///
  /// In en, this message translates to:
  /// **'Custom commands'**
  String get customCommands;

  /// No description provided for @newCustomCommand.
  ///
  /// In en, this message translates to:
  /// **'New custom command'**
  String get newCustomCommand;

  /// No description provided for @commandTrigger.
  ///
  /// In en, this message translates to:
  /// **'Trigger'**
  String get commandTrigger;

  /// No description provided for @command.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get command;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @browserStreamSettings.
  ///
  /// In en, this message translates to:
  /// **'Browser/Stream Settings'**
  String get browserStreamSettings;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add page'**
  String get addPage;

  /// No description provided for @channelStream.
  ///
  /// In en, this message translates to:
  /// **'{channel}\'s stream'**
  String channelStream(String channel);

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// No description provided for @messageAppearance.
  ///
  /// In en, this message translates to:
  /// **'Message appearance'**
  String get messageAppearance;

  /// No description provided for @showTimestamps.
  ///
  /// In en, this message translates to:
  /// **'Show timestamps'**
  String get showTimestamps;

  /// No description provided for @compactMessages.
  ///
  /// In en, this message translates to:
  /// **'Compact messages'**
  String get compactMessages;

  /// No description provided for @messageTrigger.
  ///
  /// In en, this message translates to:
  /// **'Message trigger'**
  String get messageTrigger;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @mention.
  ///
  /// In en, this message translates to:
  /// **'Mention'**
  String get mention;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @enableRegex.
  ///
  /// In en, this message translates to:
  /// **'Enable regex'**
  String get enableRegex;

  /// No description provided for @caseSensitive.
  ///
  /// In en, this message translates to:
  /// **'Case sensitive'**
  String get caseSensitive;

  /// No description provided for @messageTriggers.
  ///
  /// In en, this message translates to:
  /// **'Message triggers'**
  String get messageTriggers;

  /// No description provided for @newMessageTrigger.
  ///
  /// In en, this message translates to:
  /// **'New message trigger'**
  String get newMessageTrigger;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get copyText;

  /// No description provided for @copyTextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hold to copy message text with username'**
  String get copyTextSubtitle;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @mentionUser.
  ///
  /// In en, this message translates to:
  /// **'Mention user'**
  String get mentionUser;

  /// No description provided for @copyMessageId.
  ///
  /// In en, this message translates to:
  /// **'Copy message ID'**
  String get copyMessageId;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @userTrigger.
  ///
  /// In en, this message translates to:
  /// **'User trigger'**
  String get userTrigger;

  /// No description provided for @userTriggers.
  ///
  /// In en, this message translates to:
  /// **'User triggers'**
  String get userTriggers;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistory;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @newUserTrigger.
  ///
  /// In en, this message translates to:
  /// **'New user trigger'**
  String get newUserTrigger;

  /// No description provided for @ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get ban;

  /// No description provided for @unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get unban;

  /// No description provided for @timeoutUserForDuration.
  ///
  /// In en, this message translates to:
  /// **'Timeout user for {duration}'**
  String timeoutUserForDuration(String duration);

  /// No description provided for @chatCleared.
  ///
  /// In en, this message translates to:
  /// **'Chat was cleared'**
  String get chatCleared;

  /// No description provided for @permabanned.
  ///
  /// In en, this message translates to:
  /// **'permabanned'**
  String get permabanned;

  /// No description provided for @bannedForDuration.
  ///
  /// In en, this message translates to:
  /// **'banned for {duration}'**
  String bannedForDuration(String duration);

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get replyingTo;

  /// No description provided for @blockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Blocked message'**
  String get blockedMessage;

  /// No description provided for @showMessage.
  ///
  /// In en, this message translates to:
  /// **'Show message'**
  String get showMessage;

  /// No description provided for @hideMessage.
  ///
  /// In en, this message translates to:
  /// **'Hide message'**
  String get hideMessage;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom'**
  String get scrollToBottom;

  /// No description provided for @startUsingTheApp.
  ///
  /// In en, this message translates to:
  /// **'To start using the app, add an account below.'**
  String get startUsingTheApp;

  /// No description provided for @chatSettings.
  ///
  /// In en, this message translates to:
  /// **'Chat settings'**
  String get chatSettings;

  /// No description provided for @autocompleteUsersWithAt.
  ///
  /// In en, this message translates to:
  /// **'Autocomplete users with @'**
  String get autocompleteUsersWithAt;

  /// No description provided for @autocompleteEmotesWithColon.
  ///
  /// In en, this message translates to:
  /// **'Autocomplete emotes with :'**
  String get autocompleteEmotesWithColon;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @locale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get locale;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @justDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get justDefault;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'Someone, somewhere, will mention you someday.'**
  String get noNotifications;

  /// No description provided for @backgroundNotifications.
  ///
  /// In en, this message translates to:
  /// **'Background notifications'**
  String get backgroundNotifications;

  /// No description provided for @optionNotAvailableOnYourPlatform.
  ///
  /// In en, this message translates to:
  /// **'This option is not available on your platform.'**
  String get optionNotAvailableOnYourPlatform;

  /// No description provided for @optionNotAvailablePaywalled.
  ///
  /// In en, this message translates to:
  /// **'This option is for Chatsen supporters only.'**
  String get optionNotAvailablePaywalled;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @cache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @chatters.
  ///
  /// In en, this message translates to:
  /// **'Chatters'**
  String get chatters;

  /// No description provided for @lastSeenAgo.
  ///
  /// In en, this message translates to:
  /// **'Last seen {time} ago'**
  String lastSeenAgo(String time);

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'cs', 'da', 'de', 'el', 'en', 'es', 'fr', 'he', 'hi', 'hr', 'it', 'ja', 'ko', 'nl', 'no', 'pl', 'pt', 'ru', 'sr', 'sv', 'tr', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en': {
  switch (locale.countryCode) {
    case 'CA': return AppLocalizationsEnCa();
case 'PT': return AppLocalizationsEnPt();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return AppLocalizationsCa();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'he': return AppLocalizationsHe();
    case 'hi': return AppLocalizationsHi();
    case 'hr': return AppLocalizationsHr();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'nl': return AppLocalizationsNl();
    case 'no': return AppLocalizationsNo();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'sr': return AppLocalizationsSr();
    case 'sv': return AppLocalizationsSv();
    case 'tr': return AppLocalizationsTr();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
