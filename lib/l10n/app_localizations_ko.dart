// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return '다음 방식으로 로그인 됨: $provider';
  }

  @override
  String get termsOfService => '이용 약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get settings => '설정';

  @override
  String get expiresNever => '절대 만료되지 않음';

  @override
  String expiresIn(String time) {
    return '$time 후 만료';
  }

  @override
  String get close => '닫기';

  @override
  String get add => '추가';

  @override
  String get cancel => '취소';

  @override
  String get tokenInput => '토큰 입력';

  @override
  String get account => '계정';

  @override
  String get refreshAccount => '계정 새로고침';

  @override
  String get removeAccount => '계정 삭제';

  @override
  String get addAnotherAccount => '다른 계정 추가';

  @override
  String get verifiedUserData => '유저 데이터 확인됨!';

  @override
  String loggedInAs(String user) {
    return '$user 으로 로그인 됨';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData =>
      '유저 데이터를 확인하는데 오류가 발생하였습니다:';

  @override
  String get verifyingUserData => '유저 데이터 확인중...';

  @override
  String get verifiedUserToken => '유저 토큰 확인됨!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken =>
      '유저 토큰을 확인하는데 오류가 발생하였습니다:';

  @override
  String get verifyingUserToken => '유저 토큰 확인중...';

  @override
  String get searchForChannels => '채널 검색';

  @override
  String get recommendedChannels => '추천 채널';

  @override
  String get popularChannels => '인기있는 채널';

  @override
  String get channel => '채널';

  @override
  String get leaveChannel => '채널 나가기';

  @override
  String joinUser(String user) {
    return '$user 로 접속';
  }

  @override
  String spellCheckFailed(String username) {
    return '스펠링 체크에 실패했습니다! 혹시 $username 을 찾으셨나요?';
  }

  @override
  String joinChannelName(String channel) {
    return '$channel 참가하기';
  }

  @override
  String sendMessageIn(String channel) {
    return '$channel 에 메세지를 보내기';
  }

  @override
  String get light => '밝게';

  @override
  String get dark => '어둡게';

  @override
  String get system => '시스템 설정';

  @override
  String get appearance => '배경';

  @override
  String get highContrast => '고대비';

  @override
  String get playStream => '스트림 재생';

  @override
  String get stopStream => '스트림 중지';

  @override
  String get customCommand => '커스텀 커맨드';

  @override
  String get customCommands => '커스텀 커맨드';

  @override
  String get newCustomCommand => '새로운 커스텀 커맨드';

  @override
  String get commandTrigger => '트리거';

  @override
  String get command => '커맨드';

  @override
  String get save => '세이브';

  @override
  String get browserStreamSettings => '브라우저/스트림 설정';

  @override
  String get addPage => '페이지 추가';

  @override
  String channelStream(String channel) {
    return '$channel의 스트림';
  }

  @override
  String get openInBrowser => '브라우저에서 열기';

  @override
  String get messageAppearance => '메시지 외관';

  @override
  String get showTimestamps => '타임 스탬프 표시';

  @override
  String get compactMessages => '메시지 컴팩트화';

  @override
  String get messageTrigger => '메시지 트리거';

  @override
  String get pattern => '패턴';

  @override
  String get mention => '멘션';

  @override
  String get block => '블락';

  @override
  String get enableRegex => 'regex 활성화';

  @override
  String get caseSensitive => '대소문자 구분';

  @override
  String get messageTriggers => '메시지 트리거';

  @override
  String get newMessageTrigger => '새로운 메시지 트리거';

  @override
  String get reply => '답장';

  @override
  String get copyText => '텍스트 복사';

  @override
  String get copyTextSubtitle => '텍스트와 사용자 이름을 오래 눌러 복사';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get mentionUser => '멘션 유저';

  @override
  String get copyMessageId => '메시지 ID 복사';

  @override
  String get theme => '테마';

  @override
  String get userTrigger => '사용자 트리거';

  @override
  String get userTriggers => '사용자 트리거';

  @override
  String get chatHistory => '채팅 기록';

  @override
  String get login => '로그인';

  @override
  String get newUserTrigger => '새로운 사용자 트리거';

  @override
  String get ban => '밴';

  @override
  String get unban => '밴 취소';

  @override
  String timeoutUserForDuration(String duration) {
    return '사용자를 $duration 동안 타임아웃';
  }

  @override
  String get chatCleared => '채팅이 청소되었습니다';

  @override
  String get permabanned => '영구 밴';

  @override
  String bannedForDuration(String duration) {
    return '$duration동안 밴됨';
  }

  @override
  String get replyingTo => '~에 답장';

  @override
  String get blockedMessage => '차단된 메시지';

  @override
  String get showMessage => '메시지 보기';

  @override
  String get hideMessage => '메시지 숨기기';

  @override
  String get scrollToBottom => '맨 아래로 스크롤';

  @override
  String get startUsingTheApp => '앱을 사용하기 위해서 하단에 계정을 추가하세요.';

  @override
  String get chatSettings => '채팅 설정';

  @override
  String get autocompleteUsersWithAt => '@로 시작하여 사용자명을 자동 완성';

  @override
  String get autocompleteEmotesWithColon => ':로 시작하여 이모티콘을 자동완성';

  @override
  String get language => '언어';

  @override
  String get locale => '지역';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String get justDefault => '기본값';

  @override
  String get notifications => '알림';

  @override
  String get noNotifications => '누군가, 어디서든, 언젠간 당신에게 멘션을 보낼 것입니다.';

  @override
  String get backgroundNotifications => '백그라운드 알림';

  @override
  String get optionNotAvailableOnYourPlatform =>
      '해당 옵션은 사용자의 플랫폼에서 사용할 수 없습니다.';

  @override
  String get optionNotAvailablePaywalled => '해당 옵션은 Chatsen 후원자 전용 옵션입니다.';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get cache => '캐시';

  @override
  String get clearCache => '캐시 지우기';

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
