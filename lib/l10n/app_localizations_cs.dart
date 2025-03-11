// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Přihlášen jako $provider';
  }

  @override
  String get termsOfService => 'Podmínky služby';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get settings => 'Nastavení';

  @override
  String get expiresNever => 'Nikdy nevyprší';

  @override
  String expiresIn(String time) {
    return 'Vyprší v $time';
  }

  @override
  String get close => 'Zavřít';

  @override
  String get add => 'Přidat';

  @override
  String get cancel => 'Zrušit';

  @override
  String get tokenInput => 'Vložení tokenu';

  @override
  String get account => 'Účet';

  @override
  String get refreshAccount => 'Načíst účet';

  @override
  String get removeAccount => 'Odstranit účet';

  @override
  String get addAnotherAccount => 'Přidat jiný účet';

  @override
  String get verifiedUserData => 'Data úspěšně ověřena!';

  @override
  String loggedInAs(String user) {
    return 'Přihlášen jako $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Při ověřování osobních dat se objevil problém:';

  @override
  String get verifyingUserData => 'Ověřuji user data...';

  @override
  String get verifiedUserToken => 'Token ověřen!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Při ověřování tokenu uživatele se objevil problém:';

  @override
  String get verifyingUserToken => 'Ověřování tokenu uživatele...';

  @override
  String get searchForChannels => 'Hledat kanály';

  @override
  String get recommendedChannels => 'Doporučené kanály';

  @override
  String get popularChannels => 'Populární kanály';

  @override
  String get channel => 'Kanál';

  @override
  String get leaveChannel => 'Opustit kanál';

  @override
  String joinUser(String user) {
    return 'Připojit se k $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Kontrola pravopisu se nezdařila! Měli jste na mysli $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Připojit se k $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Poslat zprávu v $channel';
  }

  @override
  String get light => 'Světlý';

  @override
  String get dark => 'Tmavý';

  @override
  String get system => 'Systém';

  @override
  String get appearance => 'Vzhled';

  @override
  String get highContrast => 'Vysoký kontrast';

  @override
  String get playStream => 'Spustit vysílání';

  @override
  String get stopStream => 'Zastavit vysílání';

  @override
  String get customCommand => 'Vlastní příkaz';

  @override
  String get customCommands => 'Vlastní příkazy';

  @override
  String get newCustomCommand => 'Nový vlastní příkaz';

  @override
  String get commandTrigger => 'Spouštěč';

  @override
  String get command => 'Příkaz';

  @override
  String get save => 'Uložit';

  @override
  String get browserStreamSettings => 'Prohlížeč/Nastavení Vysílání';

  @override
  String get addPage => 'Přidat stranu';

  @override
  String channelStream(String channel) {
    return 'vysílání uživatele $channel';
  }

  @override
  String get openInBrowser => 'Otevřít v prohlížeči';

  @override
  String get messageAppearance => 'Vzhled zprávy';

  @override
  String get showTimestamps => 'Zobrazit časové údaje';

  @override
  String get compactMessages => 'Kompaktní zprávy';

  @override
  String get messageTrigger => 'Spouštěč zprávy';

  @override
  String get pattern => 'Vzor';

  @override
  String get mention => 'Zmínka';

  @override
  String get block => 'Zablokovat';

  @override
  String get enableRegex => 'Povolit regex';

  @override
  String get caseSensitive => 'Rozlišit malá a velká písmena';

  @override
  String get messageTriggers => 'Spouštěče zpráv';

  @override
  String get newMessageTrigger => 'Nový spouštěč zprávy';

  @override
  String get reply => 'Odpovědět';

  @override
  String get copyText => 'Zkopírovat text';

  @override
  String get copyTextSubtitle => 'Přidržením zkopírujete zprávu s uživatelským jménem';

  @override
  String get deleteMessage => 'Smazat zprávu';

  @override
  String get mentionUser => 'Zmínit uživatele';

  @override
  String get copyMessageId => 'Zkopírovat ID zprávy';

  @override
  String get theme => 'Vzhled';

  @override
  String get userTrigger => 'Spouštěč uživatele';

  @override
  String get userTriggers => 'Spouštěče uživatele';

  @override
  String get chatHistory => 'Historie zpráv';

  @override
  String get login => 'Přihlášení';

  @override
  String get newUserTrigger => 'Nový spouštěč uživatele';

  @override
  String get ban => 'Zabanovat';

  @override
  String get unban => 'Odbanovat';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Dočasně zablokovat uživatele na $duration';
  }

  @override
  String get chatCleared => 'Chat byl vymazán';

  @override
  String get permabanned => 'trvale zabanován';

  @override
  String bannedForDuration(String duration) {
    return 'zabanován po dobu $duration';
  }

  @override
  String get replyingTo => 'Odpovědět na';

  @override
  String get blockedMessage => 'Zablokovaná zpráva';

  @override
  String get showMessage => 'Zobrazit zprávu';

  @override
  String get hideMessage => 'Skrýt zprávu';

  @override
  String get scrollToBottom => 'Přejít na konec';

  @override
  String get startUsingTheApp => 'Chcete-li začít používat aplikaci, přidejte níže svůj účet.';

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
