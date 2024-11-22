import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../components/modal.dart';
import '../data/webview/cookie_data.dart';
import 'components/modal_header.dart';
import 'verify_token.dart';

// 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
// await webViewController.runJavaScript('document.cookie = "$_savedCookies"');

class OAuthWebViewModal extends StatefulWidget {
  const OAuthWebViewModal({super.key});

  @override
  State<OAuthWebViewModal> createState() => _OAuthWebViewModalState();
}

class _OAuthWebViewModalState extends State<OAuthWebViewModal> {
  WebViewController? _webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  void setup() async {
    // ignore: prefer_interpolation_to_compose_strings
    final url = 'https://id.twitch.tv/oauth2/authorize?client_id=vvxbprk8sfufgzd7k9wwr1478znf7b&redirect_uri=https://chatsen.app/oauth&response_type=token&scope=' +
        [
          // Chat
          'chat:edit',
          'chat:read',
          'channel:moderate',
          'channel:read:redemptions',
          'moderator:manage:automod',
          'channel:manage:broadcast',

          // Whispers
          'whispers:read',
          'whispers:edit',

          // Sub emotes
          'user_subscriptions',

          // Blocked users
          'user_blocks_edit',
          'user_blocks_read',
          'user:read:blocked_users',
          'user:manage:blocked_users',

          // Raid
          'channel_editor', // Raids

          // Run ads
          // 'channel_commercial',
          // 'channel:edit:commercial',

          // To create clips
          // 'clips:edit',

          // Follows, no longer working
          // 'user_follows_edit',
          // 'user:edit:follows',
        ].join('%20');

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    await cookieManager.clearCookies();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) async {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');

            if (!url.contains('access_token')) return;

            final fragmentParameters = {
              for (var fragment in Uri.parse(url).fragment.split('&').map((x) => x.split('='))) fragment.first: fragment.last,
            };

            final accessToken = fragmentParameters['access_token'];
            if (accessToken == null) return;

            final cookies = await _webViewController!.runJavaScriptReturningResult('document.cookie') as String;

            Navigator.of(context).pop();

            Modal.show(
              context: context,
              child: VerifyTokenModal(
                token: accessToken,
                cookies: cookies,
              ),
            );
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    setState(() {
      _webViewController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          if (_webViewController != null) WebViewWidget(controller: _webViewController!),
          const ModalHeader(),
        ],
      ),
    );
  }
}
