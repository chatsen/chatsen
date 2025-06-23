// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get chatsen => 'チャットセン';

  @override
  String get catsen => 'キャットセン';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return '$provider経由でログイン';
  }

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get settings => '設定';

  @override
  String get expiresNever => '期限なし';

  @override
  String expiresIn(String time) {
    return '$timeで期限切れ';
  }

  @override
  String get close => '閉じる';

  @override
  String get add => '追加';

  @override
  String get cancel => 'キャンセル';

  @override
  String get tokenInput => 'トークン入力';

  @override
  String get account => 'アカウント';

  @override
  String get refreshAccount => 'アカウントを更新';

  @override
  String get removeAccount => 'アカウントを削除';

  @override
  String get addAnotherAccount => '別のアカウントを追加';

  @override
  String get verifiedUserData => '認証済みユーザーデータ！';

  @override
  String loggedInAs(String user) {
    return '$userとしてログイン';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      'ユーザーデータの確認中にエラーが発生しました：';

  @override
  String get verifyingUserData => 'ユーザーデータを確認中...';

  @override
  String get verifiedUserToken => '認証済みユーザートークン！';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      'ユーザートークンの確認中にエラーが発生しました：';

  @override
  String get verifyingUserToken => 'ユーザートークンを確認中...';

  @override
  String get searchForChannels => 'チャンネルを検索';

  @override
  String get recommendedChannels => 'おすすめチャンネル';

  @override
  String get popularChannels => '人気チャンネル';

  @override
  String get channel => 'チャンネル';

  @override
  String get leaveChannel => 'チャンネルを退出';

  @override
  String joinUser(String user) {
    return '$userに参加';
  }

  @override
  String spellCheckFailed(String username) {
    return 'スペルチェックに失敗しました！$usernameを検索しようとしましたか？';
  }

  @override
  String joinChannelName(String channel) {
    return '$channelに参加';
  }

  @override
  String sendMessageIn(String channel) {
    return '$channelでメッセージを送信';
  }

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get system => 'システム';

  @override
  String get appearance => '外観';

  @override
  String get highContrast => 'ハイコントラスト';

  @override
  String get playStream => 'ストリームを再生';

  @override
  String get stopStream => 'ストリームを停止';

  @override
  String get customCommand => 'カスタムコマンド';

  @override
  String get customCommands => 'カスタムコマンド';

  @override
  String get newCustomCommand => '新しいカスタムコマンド';

  @override
  String get commandTrigger => 'トリガー';

  @override
  String get command => 'コマンド';

  @override
  String get save => '保存';

  @override
  String get browserStreamSettings => 'ブラウザ/ストリーム設定';

  @override
  String get addPage => 'ページを追加';

  @override
  String channelStream(String channel) {
    return '$channelのストリーム';
  }

  @override
  String get openInBrowser => 'ブラウザで開く';

  @override
  String get messageAppearance => 'メッセージの外観';

  @override
  String get showTimestamps => 'タイムスタンプを表示';

  @override
  String get compactMessages => 'コンパクトメッセージ';

  @override
  String get messageTrigger => 'メッセージトリガー';

  @override
  String get pattern => 'パターン';

  @override
  String get mention => 'メンション';

  @override
  String get block => 'ブロック';

  @override
  String get enableRegex => '正規表現を有効にする';

  @override
  String get caseSensitive => '大文字小文字を区別する';

  @override
  String get messageTriggers => 'メッセージトリガー';

  @override
  String get newMessageTrigger => '新しいメッセージトリガー';

  @override
  String get reply => '返信';

  @override
  String get copyText => 'テキストをコピー';

  @override
  String get copyTextSubtitle => 'ユーザー名とメッセージテキストをコピーするには長押し';

  @override
  String get deleteMessage => 'メッセージを削除';

  @override
  String get mentionUser => 'ユーザーにメンション';

  @override
  String get copyMessageId => 'メッセージIDをコピー';

  @override
  String get theme => 'テーマ';

  @override
  String get userTrigger => 'ユーザートリガー';

  @override
  String get userTriggers => 'ユーザートリガー';

  @override
  String get chatHistory => 'チャット履歴';

  @override
  String get login => 'ログイン';

  @override
  String get newUserTrigger => '新しいユーザートリガー';

  @override
  String get ban => 'BAN';

  @override
  String get unban => 'BAN解除';

  @override
  String timeoutUserForDuration(String duration) {
    return '$durationの間ユーザーをタイムアウト';
  }

  @override
  String get chatCleared => 'チャットがクリアされました';

  @override
  String get permabanned => '永久BAN';

  @override
  String bannedForDuration(String duration) {
    return '$durationの間BAN';
  }

  @override
  String get replyingTo => '返信先';

  @override
  String get blockedMessage => 'ブロックされたメッセージ';

  @override
  String get showMessage => 'メッセージを表示';

  @override
  String get hideMessage => 'メッセージを非表示';

  @override
  String get scrollToBottom => '下にスクロール';

  @override
  String get startUsingTheApp => 'アプリを使用するには、以下からアカウントを追加してください。';

  @override
  String get chatSettings => 'チャット設定';

  @override
  String get autocompleteUsersWithAt => '@でユーザー名を自動補完';

  @override
  String get autocompleteEmotesWithColon => ':でエモートを自動補完';

  @override
  String get language => '言語';

  @override
  String get locale => 'ロケール';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get justDefault => 'デフォルト';

  @override
  String get notifications => '通知';

  @override
  String get noNotifications => 'いつか、どこかで誰かがあなたにメンションしてくれるでしょう。';

  @override
  String get backgroundNotifications => 'バックグラウンド通知';

  @override
  String get optionNotAvailableOnYourPlatform =>
      'このオプションはお使いのプラットフォームでは利用できません。';

  @override
  String get optionNotAvailablePaywalled => 'このオプションはChatsenサポーター専用です。';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get cache => 'キャッシュ';

  @override
  String get clearCache => 'キャッシュをクリア';

  @override
  String get chatters => 'チャッター';

  @override
  String lastSeenAgo(String time) {
    return '$time前に最後に見た';
  }

  @override
  String get credits => 'Credits';

  @override
  String get search => 'Search';
}
