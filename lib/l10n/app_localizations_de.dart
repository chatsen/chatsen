// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Eingeloggt über $provider';
  }

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settings => 'Einstellungen';

  @override
  String get expiresNever => 'Läuft nie ab';

  @override
  String expiresIn(String time) {
    return 'Läuft ab in $time';
  }

  @override
  String get close => 'Schließen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get tokenInput => 'Token eingeben';

  @override
  String get account => 'Account';

  @override
  String get refreshAccount => 'Account aktualisieren';

  @override
  String get removeAccount => 'Account entfernen';

  @override
  String get addAnotherAccount => 'Weiteren Account hinzufügen';

  @override
  String get verifiedUserData => 'Benutzerdaten verifiziert!';

  @override
  String loggedInAs(String user) {
    return 'Eingeloggt als $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      'Bei der Verifizierung der Benutzerdaten ist ein Fehler aufgetreten:';

  @override
  String get verifyingUserData => 'Benutzerdaten werden verifiziert...';

  @override
  String get verifiedUserToken => 'Benutzertoken verifiziert!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      'Bei der Verifizierung des Benutzertokens ist ein Fehler aufgetreten:';

  @override
  String get verifyingUserToken => 'Benutzertoken wird verifiziert...';

  @override
  String get searchForChannels => 'Suche nach Kanälen';

  @override
  String get recommendedChannels => 'Empfohlene Kanäle';

  @override
  String get popularChannels => 'Beliebte Kanäle';

  @override
  String get channel => 'Kanal';

  @override
  String get leaveChannel => 'Kanal verlassen';

  @override
  String joinUser(String user) {
    return '$user beitreten';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Rechtschreibprüfung fehlgeschlagen! Meinen Sie $username?';
  }

  @override
  String joinChannelName(String channel) {
    return '$channel beitreten';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Nachricht in $channel senden';
  }

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get appearance => 'Darstellung';

  @override
  String get highContrast => 'Hoher Kontrast';

  @override
  String get playStream => 'Stream abspielen';

  @override
  String get stopStream => 'Stream stoppen';

  @override
  String get customCommand => 'Eigener Befehl';

  @override
  String get customCommands => 'Eigene Befehle';

  @override
  String get newCustomCommand => 'Befehl hinzufügen';

  @override
  String get commandTrigger => 'Auslöser';

  @override
  String get command => 'Befehl';

  @override
  String get save => 'Speichern';

  @override
  String get browserStreamSettings => 'Browser/Stream-Einstellungen';

  @override
  String get addPage => 'Seite hinzufügen';

  @override
  String channelStream(String channel) {
    return '$channel\'s Stream';
  }

  @override
  String get openInBrowser => 'Im Browser öffnen';

  @override
  String get messageAppearance => 'Nachrichten';

  @override
  String get showTimestamps => 'Uhrzeit anzeigen';

  @override
  String get compactMessages => 'Kompakte Darstellung';

  @override
  String get messageTrigger => 'Nachrichtenauslöser';

  @override
  String get pattern => 'Begriff';

  @override
  String get mention => 'Erwähnung';

  @override
  String get block => 'Blockieren';

  @override
  String get enableRegex => 'Regex verwenden';

  @override
  String get caseSensitive => 'Groß-/Kleinschreibung beachten';

  @override
  String get messageTriggers => 'Nachrichtenauslöser';

  @override
  String get newMessageTrigger => 'Neuer Auslöser';

  @override
  String get reply => 'Antworten';

  @override
  String get copyText => 'Kopieren';

  @override
  String get copyTextSubtitle => 'Halten, um mit Benutzernamen zu kopieren';

  @override
  String get deleteMessage => 'Nachricht löschen';

  @override
  String get mentionUser => 'Benutzer erwähnen';

  @override
  String get copyMessageId => 'Nachrichten-ID kopieren';

  @override
  String get theme => 'Farben';

  @override
  String get userTrigger => 'Nutzerauslöser';

  @override
  String get userTriggers => 'Nutzerauslöser';

  @override
  String get chatHistory => 'Chatverlauf';

  @override
  String get login => 'Login';

  @override
  String get newUserTrigger => 'Neuer Auslöser';

  @override
  String get ban => 'Sperren';

  @override
  String get unban => 'Entsperren';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Nutzer für $duration sperren';
  }

  @override
  String get chatCleared => 'Chatverlauf wurde geleert';

  @override
  String get permabanned => 'permanent gesperrt';

  @override
  String bannedForDuration(String duration) {
    return 'für $duration gesperrt';
  }

  @override
  String get replyingTo => 'Antwort an';

  @override
  String get blockedMessage => 'Blockierte Nachricht';

  @override
  String get showMessage => 'Nachricht anzeigen';

  @override
  String get hideMessage => 'Nachricht ausblenden';

  @override
  String get scrollToBottom => 'Zum Ende springen';

  @override
  String get startUsingTheApp =>
      'Fügen Sie unten ein Konto hinzu, um die App zu verwenden.';

  @override
  String get chatSettings => 'Chateinstellungen';

  @override
  String get autocompleteUsersWithAt => 'Benutzernamen mit @ vervollständigen';

  @override
  String get autocompleteEmotesWithColon => 'Emotes mit : vervollständigen';

  @override
  String get language => 'Sprache';

  @override
  String get locale => 'Sprache';

  @override
  String get systemDefault => 'Standard';

  @override
  String get justDefault => 'Standard';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get noNotifications => 'Someone, somewhere, will mention you someday.';

  @override
  String get backgroundNotifications => 'Hintergrundbenachrichtigungen';

  @override
  String get optionNotAvailableOnYourPlatform =>
      'Diese Option ist nicht für Ihre Plattform verfügbar.';

  @override
  String get optionNotAvailablePaywalled =>
      'Diese Option ist nur für Chatsen Unterstützer.';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get cache => 'Cache';

  @override
  String get clearCache => 'Chache löschen';

  @override
  String get chatters => 'Chatter';

  @override
  String lastSeenAgo(String time) {
    return 'Zuletzt gesehen vor $time';
  }

  @override
  String get credits => 'Credits';

  @override
  String get search => 'Search';
}
