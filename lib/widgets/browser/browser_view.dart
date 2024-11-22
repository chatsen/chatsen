import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BrowserView extends StatelessWidget {
  final String url;

  const BrowserView({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return WindowsBrowserView(url: url);
    }
    return MobileBrowserView(url: url);
  }
}

class MobileBrowserView extends StatelessWidget {
  final String url;
  late PlatformWebViewController _controller;

  MobileBrowserView({
    super.key,
    required this.url,
  }) {
    _controller = PlatformWebViewController(
      WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setPlatformNavigationDelegate(
        PlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams(),
        ),
      )
      ..loadRequest(
        LoadRequestParams(
          uri: Uri.parse(url),
          // uri: Uri.parse('https://player.twitch.tv/?channel=btmc&enableExtensions=true&muted=false&parent=chatsen.app&player=popout&quality=auto&volume=0.5'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context);
}

class WindowsBrowserView extends StatefulWidget {
  final String url;

  const WindowsBrowserView({
    super.key,
    required this.url,
  });

  @override
  State<WindowsBrowserView> createState() => _WindowsBrowserViewState();
}

class _WindowsBrowserViewState extends State<WindowsBrowserView> {
  late WebviewController windowsWebviewController;

  bool ready = false;

  @override
  void initState() {
    windowsWebviewController = WebviewController();
    initController();
    super.initState();
  }

  Future<void> initController() async {
    await windowsWebviewController.initialize();
    await windowsWebviewController.loadUrl(widget.url);
    setState(() {
      ready = true;
    });
  }

  @override
  Widget build(BuildContext context) => !ready
      ? const Material()
      : Webview(
          windowsWebviewController,
          permissionRequested: (url, permissionKind, isUserInitiated) {
            log('Permission requested: $url, $permissionKind, $isUserInitiated');
            return WebviewPermissionDecision.allow;
          },
        );
}
