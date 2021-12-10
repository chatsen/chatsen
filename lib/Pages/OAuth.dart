import 'dart:convert';
import 'dart:io';

import 'package:chatsen/Accounts/AccountModel.dart';
import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

/// [OAuthPage] is the page that contains our login webview. It's used to be able to add accounts to the application.
class OAuthPage extends StatefulWidget {
  final twitch.Client client;

  const OAuthPage({
    Key? key,
    required this.client,
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
                  await widget.client.swapCredentials(
                    twitch.Credentials(
                      clientId: existing.clientId,
                      id: existing.id,
                      login: existing.login!,
                      token: existing.token,
                    ),
                  );
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
                  await widget.client.swapCredentials(
                    twitch.Credentials(
                      clientId: model.clientId,
                      id: model.id,
                      login: model.login!,
                      token: model.token,
                    ),
                  );
                }

                await webViewController.clearCache();
                await cookieManager.clearCookies();
              } catch (e, stackTrace) {
                print(e);
                await Sentry.captureException(
                  e,
                  stackTrace: stackTrace,
                );
              }

              Navigator.of(context).pop();
            }
          },
          initialUrl: 'https://id.twitch.tv/oauth2/authorize?client_id=vvxbprk8sfufgzd7k9wwr1478znf7b&redirect_uri=https://chatsen.app/oauth&response_type=token&scope=' +
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
              ].join('%20'),
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'Chatsen',
        ),
      );
}
