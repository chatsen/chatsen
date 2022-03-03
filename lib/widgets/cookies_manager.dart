import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CookiesManager extends StatefulWidget {
  const CookiesManager({Key? key}) : super(key: key);

  @override
  State<CookiesManager> createState() => _CookiesManagerState();
}

class _CookiesManagerState extends State<CookiesManager> {
  List<Cookie> cookies = [];
  List<Cookie> savedCookies = [];

  Future<void> loadCookies() async {
    cookies = await WebviewCookieManager().getCookies('https://twitch.tv');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            OutlinedButton(
              child: const Text('Clear'),
              onPressed: () async {
                await CookieManager().clearCookies();
                loadCookies();
              },
            ),
            OutlinedButton(
              child: const Text('Save'),
              onPressed: () async {
                savedCookies.clear();
                savedCookies.addAll(cookies);
                loadCookies();
              },
            ),
            OutlinedButton(
              child: const Text('Load'),
              onPressed: () async {
                await WebviewCookieManager().setCookies(savedCookies);
                loadCookies();
              },
            ),
            OutlinedButton(
              child: const Text('Reload'),
              onPressed: () async {
                loadCookies();
              },
            ),
          ],
        ),
        for (var cookie in cookies) CookieWidget(cookie: cookie),
        const SizedBox(height: 1024.0),
      ],
    );
  }
}

class CookieWidget extends StatelessWidget {
  const CookieWidget({
    Key? key,
    required this.cookie,
  }) : super(key: key);

  final Cookie cookie;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(cookie.name),
              const Text('*redacted*'), // ${cookie.value}'),
              Text('${cookie.domain}'),
              Text('${cookie.path}'),
            ],
          ),
        ),
      );
}
