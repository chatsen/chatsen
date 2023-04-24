import 'dart:ffi' as dffi;
import 'dart:io';
import 'package:chatsen/data/notifications_cubit.dart';
import 'package:ffi/ffi.dart' as ffi;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatsen/data/browser/browser_state.dart';
import 'package:chatsen/data/custom_command.dart';
import 'package:chatsen/data/message_trigger.dart';
import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:chatsen/data/settings/blocked_message.dart';
import 'package:chatsen/data/settings/blocked_user.dart';
import 'package:chatsen/data/settings/chat_settings.dart';
import 'package:chatsen/data/settings/mention_message.dart';
import 'package:chatsen/data/settings/mention_user.dart';
import 'package:chatsen/data/settings/message_appearance.dart';
import 'package:chatsen/data/user_trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:win32/win32.dart';
import 'package:window_manager/window_manager.dart';

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import '/data/twitch_account.dart';
import '/data/webview/cookie_data.dart';
import '/app.dart';
import 'data/filesharing/uploaded_media.dart';
import 'tmi/client/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await Window.initialize();
  }

  await Wakelock.enable();

  await Hive.initFlutter();

  Hive.registerAdapter(TwitchAccountAdapter());
  Hive.registerAdapter(TokenDataAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(CookieDataAdapter());
  Hive.registerAdapter(UploadedMediaAdapter());
  Hive.registerAdapter(MessageAppearanceAdapter());
  Hive.registerAdapter(ApplicationAppearanceAdapter());
  Hive.registerAdapter(BlockedMessageAdapter());
  Hive.registerAdapter(BlockedUserAdapter());
  Hive.registerAdapter(MentionMessageAdapter());
  Hive.registerAdapter(MentionUserAdapter());
  Hive.registerAdapter(CustomCommandAdapter());
  Hive.registerAdapter(MessageTriggerAdapter());
  Hive.registerAdapter(UserTriggerAdapter());
  Hive.registerAdapter(ChatSettingsAdapter());

  final twitchAccountsBox = await Hive.openBox('TwitchAccounts');
  final accountSettingsBox = await Hive.openBox('AccountSettings');
  final settingsBox = await Hive.openBox('Settings');
  final channelsBox = await Hive.openBox('Channels');

  await Hive.openBox('MessageTriggers');
  await Hive.openBox('UserTriggers');
  await Hive.openBox('CustomCommands');
  await Hive.openBox('ChatSettings');

  // await settingsBox.clear();

  final activeTwitchAccount = twitchAccountsBox.values.firstWhere(
    (element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash,
    orElse: () => null,
  );

  if (!settingsBox.containsKey('messageAppearance')) await settingsBox.put('messageAppearance', MessageAppearance());
  if (!settingsBox.containsKey('applicationAppearance')) await settingsBox.put('applicationAppearance', ApplicationAppearance());
  if (!settingsBox.containsKey('chatSettings')) await settingsBox.put('chatSettings', ChatSettings());

  runApp(
    MultiProvider(
      providers: [
        Provider<Client>(
          create: (context) => Client(
            twitchAccount: activeTwitchAccount,
            channelsBox: channelsBox,
          ),
        ),
        Provider<BrowserState>(create: (context) => BrowserState()),
        Provider<NotificationsCubit>(create: (context) => NotificationsCubit()),
      ],
      child: const App(),
    ),
  );

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(240 + 128, 768);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });

    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    });
  }
}


      // final user32 = dffi.DynamicLibrary.open('user32.dll');
      // final findWindowA = user32.lookupFunction<dffi.Int32 Function(dffi.Pointer<ffi.Utf8> lpClassName, dffi.Pointer<ffi.Utf8> lpWindowName), int Function(dffi.Pointer<ffi.Utf8> lpClassName, dffi.Pointer<ffi.Utf8> lpWindowName)>('FindWindowA');
      // final getWindowLong = user32.lookupFunction<dffi.Int32 Function(dffi.Int32 hwnd, dffi.Int32 index), int Function(int lpClassName, int index)>('GetWindowLongA');
      // final setWindowLong = user32.lookupFunction<dffi.Int32 Function(dffi.Int32 hwnd, dffi.Int32 index, dffi.Int32 newLong), int Function(int lpClassName, int index, int newLong)>('SetWindowLongA');
      // final setWindowPos = user32.lookupFunction<dffi.Int32 Function(dffi.Int32 hWnd, dffi.Int32 hWndInsertAfter, dffi.Int32 X, dffi.Int32 Y, dffi.Int32 cx, dffi.Int32 cy, dffi.Uint32 uFlags), int Function(int hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags)>('SetWindowPos');

      // final hwnd = findWindowA('FLUTTER_RUNNER_WIN32_WINDOW'.toNativeUtf8(), dffi.nullptr);
      // final style = getWindowLong(hwnd, -16);
      // print(style); // -16 = GWL_STYLE

      // // const WS_BORDER = 0x00800000;
      // // const WS_CAPTION = 0x00C00000;
      // // const WS_CHILD = 0x40000000;
      // // const WS_CHILDWINDOW = 0x40000000;
      // // const WS_CLIPCHILDREN = 0x02000000;
      // // const WS_CLIPSIBLINGS = 0x04000000;
      // // const WS_DISABLED = 0x08000000;
      // // const WS_DLGFRAME = 0x00400000;
      // // const WS_GROUP = 0x00020000;
      // // const WS_HSCROLL = 0x00100000;
      // // const WS_ICONIC = 0x20000000;
      // // const WS_MAXIMIZE = 0x01000000;
      // // const WS_MAXIMIZEBOX = 0x00010000;
      // // const WS_MINIMIZE = 0x20000000;
      // // const WS_MINIMIZEBOX = 0x00020000;
      // // const WS_OVERLAPPED = 0x00000000;
      // // const WS_POPUP = 0x80000000;
      // // const WS_SIZEBOX = 0x00040000;
      // // const WS_SYSMENU = 0x00080000;
      // // const WS_TABSTOP = 0x00010000;
      // // const WS_THICKFRAME = 0x00040000;
      // // const WS_TILED = 0x00000000;
      // // const WS_VISIBLE = 0x10000000;
      // // const WS_VSCROLL = 0x00200000;
      // // const WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
      // // const WS_POPUPWINDOW = (WS_POPUP | WS_BORDER | WS_SYSMENU);
      // // const WS_TILEDWINDOW = (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);

      // const SWP_ASYNCWINDOWPOS = 0x4000;
      // const SWP_DEFERERASE = 0x2000;
      // const SWP_DRAWFRAME = 0x0020;
      // const SWP_FRAMECHANGED = 0x0020;
      // const SWP_HIDEWINDOW = 0x0080;
      // const SWP_NOACTIVATE = 0x0010;
      // const SWP_NOCOPYBITS = 0x0100;
      // const SWP_NOMOVE = 0x0002;
      // const SWP_NOOWNERZORDER = 0x0200;
      // const SWP_NOREDRAW = 0x0008;
      // const SWP_NOREPOSITION = 0x0200;
      // const SWP_NOSENDCHANGING = 0x0400;
      // const SWP_NOSIZE = 0x0001;
      // const SWP_NOZORDER = 0x0004;
      // const SWP_SHOWWINDOW = 0x0040;

      // // setWindowLong(hwnd, -16, 0x00000080 | WS_VISIBLE | 0x00000100); // WS_THICKFRAME 0x00040000

      // setWindowPos(hwnd, 0, 0, 0, 240 + 128, 768, SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
