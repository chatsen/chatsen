// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get chatsen => 'Chatsen';

  @override
  String get catsen => 'Catsen';

  @override
  String get translationAuthorNames => '';

  @override
  String loggedInVia(String provider) {
    return 'Đã đăng nhập qua $provider';
  }

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get settings => 'Cài đặt';

  @override
  String get expiresNever => 'Không bao giờ hết hạn';

  @override
  String expiresIn(String time) {
    return 'Hết hạn trong $time';
  }

  @override
  String get close => 'Đóng';

  @override
  String get add => 'Thêm';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get tokenInput => 'Nhập Token';

  @override
  String get account => 'Tài khoản';

  @override
  String get refreshAccount => 'Làm mới tài khoản';

  @override
  String get removeAccount => 'Gỡ bỏ tài khoản';

  @override
  String get addAnotherAccount => 'Thêm tài khoản khác';

  @override
  String get verifiedUserData => 'Đã xác nhận dữ liệu người dùng!';

  @override
  String loggedInAs(String user) {
    return 'Đã đăng nhập với tư cách là $user';
  }

  @override
  String get anErrorHasOccuredWhenVerifyingUserData => 'Đã có lỗi xảy ra khi xác thực dữ liệu người dùng:';

  @override
  String get verifyingUserData => 'Đang xác thực dữ liệu người dùng...';

  @override
  String get verifiedUserToken => 'Đã xác nhận Token người dùng!';

  @override
  String get anErrorHasOccuredWhenVerifyingUserToken => 'Đã có lỗi xảy ra khi xác thực mã Token người dùng:';

  @override
  String get verifyingUserToken => 'Đang xác thực mã Token người dùng...';

  @override
  String get searchForChannels => 'Tìm kiếm kênh';

  @override
  String get recommendedChannels => 'Các kênh đề xuất';

  @override
  String get popularChannels => 'Các kênh phổ biến';

  @override
  String get channel => 'Kênh';

  @override
  String get leaveChannel => 'Rời kênh';

  @override
  String joinUser(String user) {
    return 'Tham gia vào $user';
  }

  @override
  String spellCheckFailed(String username) {
    return 'Kiểm tra chính tả thất bại! Có phải bạn muốn tìm $username?';
  }

  @override
  String joinChannelName(String channel) {
    return 'Tham gia vào $channel';
  }

  @override
  String sendMessageIn(String channel) {
    return 'Gửi tin nhắn vào $channel';
  }

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get system => 'Hệ thống';

  @override
  String get appearance => 'Giao diện';

  @override
  String get highContrast => 'Độ tương phản cao';

  @override
  String get playStream => 'Phát';

  @override
  String get stopStream => 'Ngừng phát';

  @override
  String get customCommand => 'Lệnh tùy chỉnh';

  @override
  String get customCommands => 'Lệnh tùy chỉnh';

  @override
  String get newCustomCommand => 'Tạo lệnh tùy chỉnh mới';

  @override
  String get commandTrigger => 'Từ khóa Kích hoạt';

  @override
  String get command => 'Lệnh';

  @override
  String get save => 'Lưu';

  @override
  String get browserStreamSettings => 'Cài đặt Trình duyệt/Stream';

  @override
  String get addPage => 'Thêm trang';

  @override
  String channelStream(String channel) {
    return 'Kênh stream $channel';
  }

  @override
  String get openInBrowser => 'Mở trong trình duyệt';

  @override
  String get messageAppearance => 'Giao diện tin nhắn';

  @override
  String get showTimestamps => 'Hiển thị thời gian';

  @override
  String get compactMessages => 'Tin nhắn nhỏ gọn';

  @override
  String get messageTrigger => 'Bộ lọc tin nhắn';

  @override
  String get pattern => 'Nội dung';

  @override
  String get mention => 'Nhắc đến';

  @override
  String get block => 'Chặn';

  @override
  String get enableRegex => 'Bật regex';

  @override
  String get caseSensitive => 'Phân biệt in hoa';

  @override
  String get messageTriggers => 'Bộ lọc tin nhắn';

  @override
  String get newMessageTrigger => 'Tạo bộ lọc tin nhắn mới';

  @override
  String get reply => 'Trả lời';

  @override
  String get copyText => 'Sao chép văn bản';

  @override
  String get copyTextSubtitle => 'Giữ để sao chép tin nhắn với tên người dùng';

  @override
  String get deleteMessage => 'Xóa tin nhắn';

  @override
  String get mentionUser => 'Nhắc tên người dùng';

  @override
  String get copyMessageId => 'Sao chép ID tin nhắn';

  @override
  String get theme => 'Màu chủ đề';

  @override
  String get userTrigger => 'Bộ lọc người dùng';

  @override
  String get userTriggers => 'Bộ lọc người dùng';

  @override
  String get chatHistory => 'Lịch sử chat';

  @override
  String get login => 'Tên người dùng';

  @override
  String get newUserTrigger => 'Tạo bộ lọc người dùng mới';

  @override
  String get ban => 'Cấm';

  @override
  String get unban => 'Gỡ cấm';

  @override
  String timeoutUserForDuration(String duration) {
    return 'Cấm chat người dùng trong $duration';
  }

  @override
  String get chatCleared => 'Chat đã được xóa';

  @override
  String get permabanned => 'đã bị cấm vĩnh viễn';

  @override
  String bannedForDuration(String duration) {
    return 'bị cấm trong $duration';
  }

  @override
  String get replyingTo => 'Trả lời cho';

  @override
  String get blockedMessage => 'Tin nhắn bị chặn';

  @override
  String get showMessage => 'Hiển thị tin nhắn';

  @override
  String get hideMessage => 'Ẩn tin nhắn';

  @override
  String get scrollToBottom => 'Cuộn xuống cuối';

  @override
  String get startUsingTheApp => 'Để bắt đầu sử dụng, hãy thêm một tài khoản bên dưới.';

  @override
  String get chatSettings => 'Cài đặt Chat';

  @override
  String get autocompleteUsersWithAt => 'Tự động gợi ý người dùng sau dấu @';

  @override
  String get autocompleteEmotesWithColon => 'Tự động gợi ý emotes sau dấu :';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get locale => 'Ngôn ngữ';

  @override
  String get systemDefault => 'Mặc định theo hệ thống';

  @override
  String get justDefault => 'Mặc định';

  @override
  String get notifications => 'Thông báo';

  @override
  String get noNotifications => 'Một ai đó, ở đâu đó, sẽ nhắc đến bạn vào một ngày nào đó.';

  @override
  String get backgroundNotifications => 'Thông báo trong nền';

  @override
  String get optionNotAvailableOnYourPlatform => 'Tùy chọn này không có sẵn trên nền tảng của bạn.';

  @override
  String get optionNotAvailablePaywalled => 'Tùy chọn này chỉ dành cho người dùng ủng hộ Chatsen.';

  @override
  String get clearAll => 'Xoá tất cả';

  @override
  String get cache => 'Bộ nhớ đệm';

  @override
  String get clearCache => 'Xóa bộ nhớ đệm';

  @override
  String get chatters => 'Người trò chuyện';

  @override
  String lastSeenAgo(String time) {
    return 'Nhìn thấy lần cuối $time trước';
  }

  @override
  String get credits => 'Credits';

  @override
  String get search => 'Search';
}
