// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'S\'ha iniciat la sessió mitjançant $provider';
  }

  @override
  String get termsOfService => 'Condicions del Servei';

  @override
  String get privacyPolicy => 'Política de Privacitat';

  @override
  String get settings => 'Configuració';

  @override
  String get expiresNever => 'No caduca mai';

  @override
  String expiresIn(String time) {
    return 'Caduca en $time';
  }

  @override
  String get close => 'Tanca';

  @override
  String get add => 'Afegeix';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get tokenInput => 'Introdueix el token';

  @override
  String get account => 'Compte';

  @override
  String get refreshAccount => 'Actualitza el compte';

  @override
  String get removeAccount => 'Suprimeix el compte';

  @override
  String get addAnotherAccount => 'Afegeix un compte';

  @override
  String get verifiedUserData => 'Dades d\'usuari verificades!';

  @override
  String loggedInAs(String user) {
    return 'S\'ha iniciat la sessió com $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'S\'ha produït un error en verificar les dades de l\'usuari:';

  @override
  String get verifyingUserData => 'Verificant les dades de l\'usuari...';

  @override
  String get verifiedUserToken => 'Token de l\'usuari verificat!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'S\'ha produït un error en verificar el token de l\'usuari:';

  @override
  String get verifyingUserToken => 'Verificant el token de l\'usuari...';

  @override
  String get searchForChannels => 'Cerca canals';

  @override
  String get recommendedChannels => 'Canals recomanats';

  @override
  String get popularChannels => 'Canals populars';

  @override
  String get channel => 'Canal';

  @override
  String get leaveChannel => 'Deixa el canal';

  @override
  String joinUser(String user) {
    return 'Uneix-te a $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'La revisió ha fallat! Potser has volgut cercar $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Uneix-te a $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Envia missatge en $channel';
  }

  @override
  String get light => 'Clar';

  @override
  String get dark => 'Fosc';

  @override
  String get system => 'Sistema';

  @override
  String get appearance => 'Aparença';

  @override
  String get highContrast => 'Alt contrast';

  @override
  String get playStream => 'Reproduir Stream';

  @override
  String get stopStream => 'Atura stream';

  @override
  String get customCommand => 'Comanda personalitzada';

  @override
  String get customCommands => 'Comandes personalitzades';

  @override
  String get newCustomCommand => 'Nova comanda personalitzada';

  @override
  String get commandTrigger => 'Activador';

  @override
  String get command => 'Comanda';

  @override
  String get save => 'Desa';

  @override
  String get browserStreamSettings => 'Configuració del navegador/Retransmissió';

  @override
  String get addPage => 'Afegir una pàgina';

  @override
  String channelStream(String channel) {
    return 'Retransmissió de $channel';
  }

  @override
  String get openInBrowser => 'Obre al navegador';

  @override
  String get messageAppearance => 'Aparença del missatge';

  @override
  String get showTimestamps => 'Mostrar segells de temps';

  @override
  String get compactMessages => 'Missatges compactes';

  @override
  String get messageTrigger => 'Activador de missatge';

  @override
  String get pattern => 'Patró';

  @override
  String get mention => 'Menció';

  @override
  String get block => 'Bloquejar';

  @override
  String get enableRegex => 'Activar regex';

  @override
  String get caseSensitive => 'Sensible a majúscules i minúscules';

  @override
  String get messageTriggers => 'Activador de missatge';

  @override
  String get newMessageTrigger => 'Nou activador de missatge';

  @override
  String get reply => 'Respondre';

  @override
  String get copyText => 'Copiar text';

  @override
  String get copyTextSubtitle => 'Mantingueu premut per copiar el text del missatge amb el nom d\'usuari';

  @override
  String get deleteMessage => 'Eliminar missatge';

  @override
  String get mentionUser => 'Mencionar l\'usuari';

  @override
  String get copyMessageId => 'Copia l\'identificador del missatge';

  @override
  String get theme => 'Aspecte';

  @override
  String get userTrigger => 'Activador d\'usuari';

  @override
  String get userTriggers => 'Activadors d\'usuari';

  @override
  String get chatHistory => 'Historial de xat';

  @override
  String get login => 'Inici de sessió';

  @override
  String get newUserTrigger => 'Nou activador d\'usuari';

  @override
  String get ban => 'Expulsar';

  @override
  String get unban => 'Cancel·lar Expulsió';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Expulsar temporalment per $duration';
  }

  @override
  String get chatCleared => 'El xat s\'ha esborrat';

  @override
  String get permabanned => 'expulsat indefinitivament';

  @override
  String bannedForDuration(String duration) {
    return 'expulsat per $duration';
  }

  @override
  String get replyingTo => 'Responent a';

  @override
  String get blockedMessage => 'Missatge bloquejat';

  @override
  String get showMessage => 'Mostra el missatge';

  @override
  String get hideMessage => 'Amagar el missatge';

  @override
  String get scrollToBottom => 'Desplaça al final';

  @override
  String get startUsingTheApp => 'Per començar a utilitzar l\'aplicació, afegiu un compte a continuació.';

  @override
  String get chatSettings => 'Configuració del xat';

  @override
  String get autocompleteUsersWithAt => 'Completa els usuaris automàticament amb @';

  @override
  String get autocompleteEmotesWithColon => 'Completa els emotes automàticament amb :';

  @override
  String get language => 'Llenguatge';

  @override
  String get locale => 'Local';

  @override
  String get systemDefault => 'Valors per defecte del sistema';

  @override
  String get justDefault => 'Predeterminat';

  @override
  String get notifications => 'Notificacions';

  @override
  String get noNotifications => 'Algú, en algun lloc, t\'esmentarà algun dia.';

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
