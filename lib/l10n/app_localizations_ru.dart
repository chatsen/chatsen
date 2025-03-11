// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Вы вошли через $provider';
  }

  @override
  String get termsOfService => 'Условия предоставления услуг';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get settings => 'Настройки';

  @override
  String get expiresNever => 'Никогда не истекает';

  @override
  String expiresIn(String time) {
    return 'Срок истекает через $time';
  }

  @override
  String get close => 'Закрыть';

  @override
  String get add => 'Добавить';

  @override
  String get cancel => 'Отмена';

  @override
  String get tokenInput => 'Ввод токена';

  @override
  String get account => 'Учётная запись';

  @override
  String get refreshAccount => 'Обновить учётную запись';

  @override
  String get removeAccount => 'Удалить учётную запись';

  @override
  String get addAnotherAccount => 'Добавить другую учётную запись';

  @override
  String get verifiedUserData => 'Данные пользователя подтверждены!';

  @override
  String loggedInAs(String user) {
    return 'Вы вошли как $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Произошла ошибка при проверке данных пользователя:';

  @override
  String get verifyingUserData => 'Проверка данных пользователя...';

  @override
  String get verifiedUserToken => 'Токен пользователя подтвержден!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Произошла ошибка при проверке токена пользователя:';

  @override
  String get verifyingUserToken => 'Проверка токена пользователя...';

  @override
  String get searchForChannels => 'Поиск каналов';

  @override
  String get recommendedChannels => 'Рекомендованные каналы';

  @override
  String get popularChannels => 'Популярные каналы';

  @override
  String get channel => 'Канал';

  @override
  String get leaveChannel => 'Покинуть канал';

  @override
  String joinUser(String user) {
    return 'Присоединиться к $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Ой, кажется очепятка! Вы хотели найти $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Присоединиться к $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Отправить сообщение в $channel';
  }

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get highContrast => 'Высокая контрастность';

  @override
  String get playStream => 'Воспроизвести трансляцию';

  @override
  String get stopStream => 'Остановить трансляцию';

  @override
  String get customCommand => 'Собственная команда';

  @override
  String get customCommands => 'Собственные команды';

  @override
  String get newCustomCommand => 'Новая собственная команда';

  @override
  String get commandTrigger => 'Замена текста';

  @override
  String get command => 'Команда';

  @override
  String get save => 'Сохранить';

  @override
  String get browserStreamSettings => 'Настройки браузера/трансляции';

  @override
  String get addPage => 'Добавить страницу';

  @override
  String channelStream(String channel) {
    return 'трансляция $channel';
  }

  @override
  String get openInBrowser => 'Открыть в браузере';

  @override
  String get messageAppearance => 'Внешний вид сообщения';

  @override
  String get showTimestamps => 'Показывать временные отметки';

  @override
  String get compactMessages => 'Компактный вид сообщений';

  @override
  String get messageTrigger => 'Ключевое слово';

  @override
  String get pattern => 'Шаблон';

  @override
  String get mention => 'Выделить в чате';

  @override
  String get block => 'Заблокировать';

  @override
  String get enableRegex => 'Включить regex';

  @override
  String get caseSensitive => 'Учитывать регистр';

  @override
  String get messageTriggers => 'Ключевые слова в сообщениях';

  @override
  String get newMessageTrigger => 'Добавить новое ключевое слово';

  @override
  String get reply => 'Ответить';

  @override
  String get copyText => 'Скопировать текст';

  @override
  String get copyTextSubtitle => 'Удерживайте, чтобы скопировать текст сообщения с именем пользователя';

  @override
  String get deleteMessage => 'Удалить сообщение';

  @override
  String get mentionUser => 'Упомянуть пользователя';

  @override
  String get copyMessageId => 'Скопировать ID сообщения';

  @override
  String get theme => 'Тема';

  @override
  String get userTrigger => 'Действия при определённом пользователе';

  @override
  String get userTriggers => 'Действия при пользователях';

  @override
  String get chatHistory => 'История сообщений';

  @override
  String get login => 'Имя пользователя';

  @override
  String get newUserTrigger => 'Добавить новое действие при пользователе';

  @override
  String get ban => 'Забанить';

  @override
  String get unban => 'Разбанить';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Временно отстранить пользователя на $duration';
  }

  @override
  String get chatCleared => 'Чат был очищен';

  @override
  String get permabanned => 'забанен';

  @override
  String bannedForDuration(String duration) {
    return 'отстранён на $duration';
  }

  @override
  String get replyingTo => 'Ответить на';

  @override
  String get blockedMessage => 'Скрытое сообщение';

  @override
  String get showMessage => 'Показать сообщение';

  @override
  String get hideMessage => 'Скрыть сообщение';

  @override
  String get scrollToBottom => 'Прокрутить вниз';

  @override
  String get startUsingTheApp => 'Чтобы начать использовать приложение, добавьте учётную запись ниже.';

  @override
  String get chatSettings => 'Настройки чата';

  @override
  String get autocompleteUsersWithAt => 'Предлагать имена пользователей после ввода @';

  @override
  String get autocompleteEmotesWithColon => 'Предлагать смайлики после ввода :';

  @override
  String get language => 'Язык';

  @override
  String get locale => 'Настройки языка';

  @override
  String get systemDefault => 'Системные настройки';

  @override
  String get justDefault => 'По умолчанию';

  @override
  String get notifications => 'Уведомления';

  @override
  String get noNotifications => 'Кто-то, где-то, обязательно упомянет вас когда-нибудь.';

  @override
  String get backgroundNotifications => 'Фоновые уведомления';

  @override
  String get optionNotAvailableOnYourPlatform => 'Эта опция недоступна на вашей операционной системе.';

  @override
  String get optionNotAvailablePaywalled => 'Эта опция предназначена только для спонсоров Chatsen.';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get cache => 'Кэш';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get chatters => 'Участники чата';

  @override
  String lastSeenAgo(String time) {
    return 'Последний раз видели $time назад';
  }

  @override
  String get credits => 'Благодарности';

  @override
  String get search => 'Поиск';
}
