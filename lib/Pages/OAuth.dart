import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '/MVP/Presenters/AccountPresenter.dart';
import '/MVP/Models/AccountModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

/// [OAuthPage] is the page that contains our login webview. It's used to be able to add accounts to the application.
class OAuthPage extends StatefulWidget {
  final Function refresh;

  const OAuthPage({
    Key? key,
    required this.refresh,
  }) : super(key: key);

  @override
  _OAuthPageState createState() => _OAuthPageState();
}

class _OAuthPageState extends State<OAuthPage> {
  late WebViewController webViewController;
  CookieManager cookieManager = CookieManager();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Login with Twitch'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await webViewController.clearCache();
                await cookieManager.clearCookies();
              },
            ),
          ],
        ),
        body: WebView(
          onWebViewCreated: (controller) => webViewController = controller,
          onPageFinished: (url) async {
            print('wow url: $url');
            if (url.contains('access_token')) {
              try {
                var fragmentParameters = {
                  for (var fragment in Uri.parse(url).fragment.split('&').map((x) => x.split('='))) fragment.first: fragment.last,
                };

                var response = await http.get(
                  Uri.parse('https://api.twitch.tv/helix/users'),
                  headers: {
                    'Authorization': 'Bearer ${fragmentParameters['access_token']}',
                    'Client-Id': 'vvxbprk8sfufgzd7k9wwr1478znf7b',
                  },
                );
                var responseJson = jsonDecode(utf8.decode(response.bodyBytes));

                var imageBytes = (await http.get(Uri.parse(responseJson['data'][0]['profile_image_url']))).bodyBytes;

                var data = await AccountPresenter.loadData();
                var existing = data.firstWhere((model) => model!.id == (int.tryParse(responseJson['data'][0]['id']) ?? -1), orElse: () => null);

                if (existing != null) {
                  existing.clientId = 'vvxbprk8sfufgzd7k9wwr1478znf7b';
                  existing.token = fragmentParameters['access_token'];
                  existing.id = int.tryParse(responseJson['data'][0]['id']) ?? 0;
                  existing.login = responseJson['data'][0]['login'];
                  existing.avatarBytes = imageBytes;
                  await existing.save();
                } else {
                  data.add(
                    AccountModel(
                      clientId: 'vvxbprk8sfufgzd7k9wwr1478znf7b',
                      token: fragmentParameters['access_token'],
                      id: int.tryParse(responseJson['data'][0]['id']) ?? 0,
                      login: responseJson['data'][0]['login'],
                      avatarBytes: imageBytes,
                    ),
                  );

                  await AccountPresenter.saveData(data);
                }

                await webViewController.clearCache();
                await cookieManager.clearCookies();
              } catch (e) {
                print(e);
              }

              Navigator.of(context).pop();
              widget.refresh();
            }
          },
          initialUrl: 'https://id.twitch.tv/oauth2/authorize?client_id=vvxbprk8sfufgzd7k9wwr1478znf7b&redirect_uri=https://chatsen.app&response_type=token&scope=user_subscriptions%20user_blocks_edit%20user_blocks_read%20user_follows_edit%20channel_editor%20channel:moderate%20channel:read:redemptions%20chat:edit%20chat:read%20whispers:read%20whispers:edit%20channel_commercial%20channel:edit:commercial%20user:edit:follows%20clips:edit%20channel:manage:broadcast%20user:read:blocked_users%20user:manage:blocked_users%20moderator:manage:automod',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0',
        ),
      );
}
