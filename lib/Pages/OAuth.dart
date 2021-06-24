import 'dart:convert';
import 'dart:io';

import 'package:chatsen/Accounts/AccountModel.dart';
import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

/// [OAuthPage] is the page that contains our login webview. It's used to be able to add accounts to the application.
class OAuthPage extends StatefulWidget {
  const OAuthPage({
    Key? key,
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
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () async {
            //     await webViewController.clearCache();
            //     await cookieManager.clearCookies();
            //   },
            // ),
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

                var cubit = BlocProvider.of<AccountsCubit>(context);

                var existing = cubit.state.firstWhereOrNull((model) => model.id == (int.tryParse(responseJson['data'][0]['id']) ?? -1));
                if (existing != null) {
                  existing.clientId = 'vvxbprk8sfufgzd7k9wwr1478znf7b';
                  existing.token = fragmentParameters['access_token'];
                  existing.id = int.tryParse(responseJson['data'][0]['id']) ?? 0;
                  existing.login = responseJson['data'][0]['login'];
                  existing.avatarBytes = imageBytes;
                  await existing.save();
                  await cubit.setActive(existing);
                } else {
                  var model = AccountModel(
                    clientId: 'vvxbprk8sfufgzd7k9wwr1478znf7b',
                    token: fragmentParameters['access_token'],
                    id: int.tryParse(responseJson['data'][0]['id']) ?? 0,
                    login: responseJson['data'][0]['login'],
                    avatarBytes: imageBytes,
                  );
                  await cubit.add(model);
                  await cubit.setActive(model);
                }

                await webViewController.clearCache();
                await cookieManager.clearCookies();
              } catch (e) {
                print(e);
              }

              Navigator.of(context).pop();
            }
          },
          initialUrl: 'https://id.twitch.tv/oauth2/authorize?client_id=vvxbprk8sfufgzd7k9wwr1478znf7b&redirect_uri=https://chatsen.app&response_type=token&scope=user_subscriptions%20user_blocks_edit%20user_blocks_read%20user_follows_edit%20channel_editor%20channel:moderate%20channel:read:redemptions%20chat:edit%20chat:read%20whispers:read%20whispers:edit%20channel_commercial%20channel:edit:commercial%20user:edit:follows%20clips:edit%20channel:manage:broadcast%20user:read:blocked_users%20user:manage:blocked_users%20moderator:manage:automod',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0',
        ),
      );
}
