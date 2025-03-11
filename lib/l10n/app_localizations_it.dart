// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Connesso tramite $provider';
  }

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get privacyPolicy => 'Politica sulla Privacy';

  @override
  String get settings => 'Impostazioni';

  @override
  String get expiresNever => 'Senza scadenza';

  @override
  String expiresIn(String time) {
    return 'Scade tra $time';
  }

  @override
  String get close => 'Chiudi';

  @override
  String get add => 'Aggiungi';

  @override
  String get cancel => 'Cancella';

  @override
  String get tokenInput => 'Inserire Token';

  @override
  String get account => 'Profilo';

  @override
  String get refreshAccount => 'Rinnova profilo';

  @override
  String get removeAccount => 'Rimuovi profilo';

  @override
  String get addAnotherAccount => 'Aggiungi un altro profilo';

  @override
  String get verifiedUserData => 'Dati utente verificati!';

  @override
  String loggedInAs(String user) {
    return 'Connesso come $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Si è verificato un errore durante la verifica dei dati utente:';

  @override
  String get verifyingUserData => 'Verificando dati utente...';

  @override
  String get verifiedUserToken => 'Token utente verificato!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Si è verificato un errore durante la verifica del token utente:';

  @override
  String get verifyingUserToken => 'Verificando token utente...';

  @override
  String get searchForChannels => 'Cerca un canale';

  @override
  String get recommendedChannels => 'Canali Raccomandati';

  @override
  String get popularChannels => 'Canali Popolari';

  @override
  String get channel => 'Canale';

  @override
  String get leaveChannel => 'Lascia il canale';

  @override
  String joinUser(String user) {
    return 'Unisciti a $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Controllo ortografico fallito! Intendevi forse cercare $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Partecipa in $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Invia messaggio in $channel';
  }

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get system => 'Sistema';

  @override
  String get appearance => 'Aspetto';

  @override
  String get highContrast => 'Contrasto elevato';

  @override
  String get playStream => 'Riproduci lo stream';

  @override
  String get stopStream => 'Ferma lo stream';

  @override
  String get customCommand => 'Comando personalizzato';

  @override
  String get customCommands => 'Comandi Personalizzati';

  @override
  String get newCustomCommand => 'Nuovo comando personalizzato';

  @override
  String get commandTrigger => 'Trigger';

  @override
  String get command => 'Comando';

  @override
  String get save => 'Salva';

  @override
  String get browserStreamSettings => 'Impostazioni Browser/Stream';

  @override
  String get addPage => 'Aggiungi pagina';

  @override
  String channelStream(String channel) {
    return 'Stream di $channel';
  }

  @override
  String get openInBrowser => 'Apri nel browser';

  @override
  String get messageAppearance => 'Aspetto messaggio';

  @override
  String get showTimestamps => 'Mostra timestamp';

  @override
  String get compactMessages => 'Compatta messaggi';

  @override
  String get messageTrigger => 'Trigger messaggio';

  @override
  String get pattern => 'Modello';

  @override
  String get mention => 'Menzione';

  @override
  String get block => 'Blocca';

  @override
  String get enableRegex => 'Abilita regex';

  @override
  String get caseSensitive => 'Sensibile alle maiuscole';

  @override
  String get messageTriggers => 'Triggers messaggio';

  @override
  String get newMessageTrigger => 'Nuovo trigger messaggio';

  @override
  String get reply => 'Rispondi';

  @override
  String get copyText => 'Copia testo';

  @override
  String get copyTextSubtitle => 'Tieni premuto per copiare il testo del messaggio con il nome utente';

  @override
  String get deleteMessage => 'Cancella messaggio';

  @override
  String get mentionUser => 'Menziona utente';

  @override
  String get copyMessageId => 'Copia ID del messaggio';

  @override
  String get theme => 'Tema';

  @override
  String get userTrigger => 'Trigger utente';

  @override
  String get userTriggers => 'Triggers utente';

  @override
  String get chatHistory => 'Cronologia chat';

  @override
  String get login => 'Accedi';

  @override
  String get newUserTrigger => 'Nuovo trigger utente';

  @override
  String get ban => 'Banna';

  @override
  String get unban => 'Sbanna';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Banna temporaneamente l\'utente per $duration';
  }

  @override
  String get chatCleared => 'La chat è stata cancellata';

  @override
  String get permabanned => 'bannato permanentemente';

  @override
  String bannedForDuration(String duration) {
    return 'bannato per $duration';
  }

  @override
  String get replyingTo => 'In risposta a';

  @override
  String get blockedMessage => 'Messaggio bloccato';

  @override
  String get showMessage => 'Mostra messaggio';

  @override
  String get hideMessage => 'Nascondi messaggio';

  @override
  String get scrollToBottom => 'Scorri in fondo';

  @override
  String get startUsingTheApp => 'Per iniziare a utilizzare l\'app, aggiungi un account qui sotto.';

  @override
  String get chatSettings => 'Impostazioni della Chat';

  @override
  String get autocompleteUsersWithAt => 'Autocompleta nomi utente con @';

  @override
  String get autocompleteEmotesWithColon => 'Autocompleta emote con :';

  @override
  String get language => 'Lingua';

  @override
  String get locale => 'Localizzazione';

  @override
  String get systemDefault => 'Predefinita di Sistema';

  @override
  String get justDefault => 'Predefinita';

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
