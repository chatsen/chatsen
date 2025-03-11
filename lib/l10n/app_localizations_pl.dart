// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Zalogowano przez $provider';
  }

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get privacyPolicy => 'Polityka Prywatności';

  @override
  String get settings => 'Ustawienia';

  @override
  String get expiresNever => 'Nigdy nie wygasa';

  @override
  String expiresIn(String time) {
    return 'Wygasa za $time';
  }

  @override
  String get close => 'Zamknij';

  @override
  String get add => 'Dodaj';

  @override
  String get cancel => 'Anuluj';

  @override
  String get tokenInput => 'Dodaj token';

  @override
  String get account => 'Konto';

  @override
  String get refreshAccount => 'Odśwież konto';

  @override
  String get removeAccount => 'Usuń konto';

  @override
  String get addAnotherAccount => 'Dodaj kolejne konto';

  @override
  String get verifiedUserData => 'Zweryfikowano dane użytkownika!';

  @override
  String loggedInAs(String user) {
    return 'Zalogowano jako $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Wystąpił problem podczas weryfikacji danych użytkownika:';

  @override
  String get verifyingUserData => 'Weryfikowanie danych użytkownika...';

  @override
  String get verifiedUserToken => 'Zwerifikowano token użytkownika!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Wystąpił problem podczas weryfikacji tokenu użytkownika:';

  @override
  String get verifyingUserToken => 'Weryfikowanie tokenu użytkownika...';

  @override
  String get searchForChannels => 'Wyszukaj kanały';

  @override
  String get recommendedChannels => 'Polecane kanały';

  @override
  String get popularChannels => 'Popularne kanały';

  @override
  String get channel => 'Kanał';

  @override
  String get leaveChannel => 'Opuść kanał';

  @override
  String joinUser(String user) {
    return 'Dołącz $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Sprawdzanie pisowni nie powiodło się! Czy chciałeś wyszukać $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Dołącz do $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Wyślij wiadomość w $channel';
  }

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';

  @override
  String get system => 'Systemowy';

  @override
  String get appearance => 'Wygląd';

  @override
  String get highContrast => 'Wysoki kontrast';

  @override
  String get playStream => 'Wznów strumień';

  @override
  String get stopStream => 'Zatrzymaj strumień';

  @override
  String get customCommand => 'Niestandardowe polecenie';

  @override
  String get customCommands => 'Niestandardowe polecenia';

  @override
  String get newCustomCommand => 'Nowe niestandardowe polecenie';

  @override
  String get commandTrigger => 'Wyzwalacz';

  @override
  String get command => 'Polecenie';

  @override
  String get save => 'Zapisz';

  @override
  String get browserStreamSettings => 'Ustawienia Wyszukiwarki/Strumienia';

  @override
  String get addPage => 'Dodaj stronę';

  @override
  String channelStream(String channel) {
    return 'Strumień $channel';
  }

  @override
  String get openInBrowser => 'Otwórz w przeglądarce';

  @override
  String get messageAppearance => 'Wygląd wiadomości';

  @override
  String get showTimestamps => 'Pokaż znaczniki czasu';

  @override
  String get compactMessages => 'Kompaktowe wiadomości';

  @override
  String get messageTrigger => 'Wyzwalacz wiadomości';

  @override
  String get pattern => 'Wzorzec';

  @override
  String get mention => 'Wzmianka';

  @override
  String get block => 'Zablokuj';

  @override
  String get enableRegex => 'Włącz regex';

  @override
  String get caseSensitive => 'Rozróżniaj wielkość liter';

  @override
  String get messageTriggers => 'Wyzwalacze wiadomości';

  @override
  String get newMessageTrigger => 'Nowy wyzwalacz wiadomości';

  @override
  String get reply => 'Odpowiedz';

  @override
  String get copyText => 'Kopiuj tekst';

  @override
  String get copyTextSubtitle => 'Przytrzymaj, aby skopiować tekst z nazwą użytkownika';

  @override
  String get deleteMessage => 'Usuń wiadomość';

  @override
  String get mentionUser => 'Wspomnij użytkownika';

  @override
  String get copyMessageId => 'Kopiuj ID wiadomości';

  @override
  String get theme => 'Motyw';

  @override
  String get userTrigger => 'Wyzwalacz użytkownika';

  @override
  String get userTriggers => 'Wyzwalacze użytkownika';

  @override
  String get chatHistory => 'Historia czatu';

  @override
  String get login => 'Zaloguj się';

  @override
  String get newUserTrigger => 'Nowy wyzwalacz użytkownika';

  @override
  String get ban => 'Zbanuj';

  @override
  String get unban => 'Odbanuj';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Wyklucz użytkownika na $duration';
  }

  @override
  String get chatCleared => 'Czat został wyczyszczony';

  @override
  String get permabanned => 'permanentnie zbanowany';

  @override
  String bannedForDuration(String duration) {
    return 'zbanowano na $duration';
  }

  @override
  String get replyingTo => 'Odpowiadasz';

  @override
  String get blockedMessage => 'Zablokowana wiadomość';

  @override
  String get showMessage => 'Pokaż wiadomość';

  @override
  String get hideMessage => 'Ukryj wiadomość';

  @override
  String get scrollToBottom => 'Przewiń na dół';

  @override
  String get startUsingTheApp => 'Dodaj konto poniżej, aby zacząć korzystać z aplikacji.';

  @override
  String get chatSettings => 'Ustawienia czatu';

  @override
  String get autocompleteUsersWithAt => 'Autouzupełnianie użytkowników używając @';

  @override
  String get autocompleteEmotesWithColon => 'Autouzupełnianie emotek używając :';

  @override
  String get language => 'Język';

  @override
  String get locale => 'Ustawienia regionalne';

  @override
  String get systemDefault => 'Domyślne systemu';

  @override
  String get justDefault => 'Domyślne';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get noNotifications => 'Ktoś, gdzieś, kiedyś o Tobie wspomni.';

  @override
  String get backgroundNotifications => 'Powiadomienia w tle';

  @override
  String get optionNotAvailableOnYourPlatform => 'Ta opcja nie jest dostępna na twojej platformie.';

  @override
  String get optionNotAvailablePaywalled => 'Ta opcja jest tylko dla wspierających Chatsen.';

  @override
  String get clearAll => 'Wyczyść wszystko';

  @override
  String get cache => 'Cache';

  @override
  String get clearCache => 'Wyczyść cache';

  @override
  String get chatters => 'Czatownicy';

  @override
  String lastSeenAgo(String time) {
    return 'Ostatnio widziany $time temu';
  }

  @override
  String get credits => 'Credits';

  @override
  String get search => 'Search';
}
