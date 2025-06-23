// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Conectado via $provider';
  }

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get settings => 'Configurações';

  @override
  String get expiresNever => 'Nunca expira';

  @override
  String expiresIn(String time) {
    return 'Expira em $time';
  }

  @override
  String get close => 'Fechar';

  @override
  String get add => 'Adicionar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get tokenInput => 'Entrada de token';

  @override
  String get account => 'Conta';

  @override
  String get refreshAccount => 'Atualizar conta';

  @override
  String get removeAccount => 'Remover conta';

  @override
  String get addAnotherAccount => 'Adicionar outra conta';

  @override
  String get verifiedUserData => 'Dados do usuário verificados!';

  @override
  String loggedInAs(String user) {
    return 'Logado como $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      'Ocorreu um erro ao verificar os dados do usuário:';

  @override
  String get verifyingUserData => 'Verificando dados do usuário...';

  @override
  String get verifiedUserToken => 'Token do usuário verificado!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      'Ocorreu um erro ao verificar o token do usuário:';

  @override
  String get verifyingUserToken => 'Verificando token de usuário...';

  @override
  String get searchForChannels => 'Procurar por canais';

  @override
  String get recommendedChannels => 'Canais recomendados';

  @override
  String get popularChannels => 'Canais populares';

  @override
  String get channel => 'Canal';

  @override
  String get leaveChannel => 'Sair do canal';

  @override
  String joinUser(String user) {
    return 'Entrar $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'A verificação ortográfica falhou! Você queria pesquisar por $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Conectar $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Enviar mensagem em $channel';
  }

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get system => 'Sistema';

  @override
  String get appearance => 'Aparência';

  @override
  String get highContrast => 'Alto contraste';

  @override
  String get playStream => 'Reproduzir transmissão';

  @override
  String get stopStream => 'Parar transmissão';

  @override
  String get customCommand => 'Comando personalizado';

  @override
  String get customCommands => 'Comandos personalizados';

  @override
  String get newCustomCommand => 'Novo comando personalizado';

  @override
  String get commandTrigger => 'Gatilho';

  @override
  String get command => 'Comando';

  @override
  String get save => 'Salvar';

  @override
  String get browserStreamSettings => 'Configurações de Navegador/Transmissão';

  @override
  String get addPage => 'Adicionar página';

  @override
  String channelStream(String channel) {
    return 'Transmissão de $channel';
  }

  @override
  String get openInBrowser => 'Abrir no navegador';

  @override
  String get messageAppearance => 'Aparência das mensagens';

  @override
  String get showTimestamps => 'Mostrar timestamps';

  @override
  String get compactMessages => 'Mensagens compactas';

  @override
  String get messageTrigger => 'Gatilho de mensagem';

  @override
  String get pattern => 'Padrão';

  @override
  String get mention => 'Menção';

  @override
  String get block => 'Bloquear';

  @override
  String get enableRegex => 'Habilitar regex';

  @override
  String get caseSensitive => 'Sensível a maiúsculas e minúsculas';

  @override
  String get messageTriggers => 'Gatilhos de mensagem';

  @override
  String get newMessageTrigger => 'Novo gatilho de mensagem';

  @override
  String get reply => 'Responder';

  @override
  String get copyText => 'Copiar texto';

  @override
  String get copyTextSubtitle =>
      'Segure para copiar o texto da mensagem com o usuário';

  @override
  String get deleteMessage => 'Excluir mensagem';

  @override
  String get mentionUser => 'Mencionar usuário';

  @override
  String get copyMessageId => 'Copiar ID da mensagem';

  @override
  String get theme => 'Tema';

  @override
  String get userTrigger => 'Gatilho de usuário';

  @override
  String get userTriggers => 'Gatilhos de usuário';

  @override
  String get chatHistory => 'Histórico de chat';

  @override
  String get login => 'Iniciar sessão';

  @override
  String get newUserTrigger => 'Novo gatilho de usuário';

  @override
  String get ban => 'Banir';

  @override
  String get unban => 'Desbanir';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Suspender usuário por $duration';
  }

  @override
  String get chatCleared => 'O chat foi limpo';

  @override
  String get permabanned => 'banido permanentemente';

  @override
  String bannedForDuration(String duration) {
    return 'banido por $duration';
  }

  @override
  String get replyingTo => 'Respondendo a';

  @override
  String get blockedMessage => 'Mensagem bloqueada';

  @override
  String get showMessage => 'Mostrar mensagem';

  @override
  String get hideMessage => 'Ocultar mensagem';

  @override
  String get scrollToBottom => 'Rolar para o final';

  @override
  String get startUsingTheApp =>
      'Para começar a usar o aplicativo, adicione uma conta abaixo.';

  @override
  String get chatSettings => 'Configurações do chat';

  @override
  String get autocompleteUsersWithAt => 'Autocompletar usuários com @';

  @override
  String get autocompleteEmotesWithColon => 'Autocompletar emotes com :';

  @override
  String get language => 'Idioma';

  @override
  String get locale => 'Localidade';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get justDefault => 'Padrão';

  @override
  String get notifications => 'Notificações';

  @override
  String get noNotifications =>
      'Alguém, em algum lugar, vai te mencionar um dia.';

  @override
  String get backgroundNotifications => 'Notificações em segundo plano';

  @override
  String get optionNotAvailableOnYourPlatform =>
      'Essa opção não está disponível na sua plataforma.';

  @override
  String get optionNotAvailablePaywalled =>
      'Esta opção é apenas para apoiadores do Chatsen.';

  @override
  String get clearAll => 'Limpar tudo';

  @override
  String get cache => 'Cache';

  @override
  String get clearCache => 'Limpar cache';

  @override
  String get chatters => 'Chatters';

  @override
  String lastSeenAgo(String time) {
    return 'Visto pela última vez $time atrás';
  }

  @override
  String get credits => 'Créditos';

  @override
  String get search => 'Pesquisar';
}
