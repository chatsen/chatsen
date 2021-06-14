import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/MVP/Presenters/AccountPresenter.dart';
import '/MVP/Models/AccountModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

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
        ),
        body: WebView(
          onWebViewCreated: (controller) => webViewController = controller,
          onPageFinished: (_) async {
            print(await webViewController.evaluateJavascript('document.cookie.split(";")'));

            var jsCookies = await webViewController.evaluateJavascript(Platform.isAndroid
                ? '''
                      document.cookie.split(";").reduce((res, c) => {
                        const [key, val] = c.trim().split("=").map(decodeURIComponent)
                        try {
                          return Object.assign(res, {[key]: JSON.parse(val)})
                        } catch (e) {
                          return Object.assign(res, {[key]: val})
                        }
                      }, {});
                    '''
                : '''
                      JSON.stringify(document.cookie.split(";").reduce((res, c) => {
                        const [key, val] = c.trim().split("=").map(decodeURIComponent)
                        try {
                          return Object.assign(res, {[key]: JSON.parse(val)})
                        } catch (e) {
                          return Object.assign(res, {[key]: val})
                        }
                      }, {}));
                    ''');

            print(jsCookies);

            // ...Really?
            Map<String, dynamic> cookies = jsonDecode(jsCookies);

            if (cookies.containsKey('twilight-user')) {
              print(cookies);

              try {
                var profileInfo = await twitch.GQL.request('''
                      query {
                        user(id: "${cookies['twilight-user']['id']}", lookupType: ALL) {
                          profileImageURL(width: 150)
                        }
                      }
                    ''');

                var profileAvatarUrl = profileInfo['data']['user']['profileImageURL'];

                var bytes = (await NetworkAssetBundle(Uri.parse(profileAvatarUrl)).load(profileAvatarUrl)).buffer.asUint8List();
                print(bytes);

                var data = await AccountPresenter.loadData();
                var existing = data.firstWhere((model) => model!.id == (int.tryParse(cookies['twilight-user']['id']) ?? -1), orElse: () => null);

                if (existing != null) {
                  existing.token = cookies['twilight-user']['authToken'];
                  existing.id = int.tryParse(cookies['twilight-user']['id']) ?? 0;
                  existing.login = cookies['twilight-user']['login'];
                  existing.avatarBytes = bytes;
                  await existing.save();
                } else {
                  data.add(
                    AccountModel(
                      clientId: 'kimne78kx3ncx6brgo4mv6wki5h1ko',
                      token: cookies['twilight-user']['authToken'],
                      id: int.tryParse(cookies['twilight-user']['id']) ?? 0,
                      login: cookies['twilight-user']['login'],
                      avatarBytes: bytes,
                    ),
                  );

                  AccountPresenter.saveData(data);
                }
              } catch (e) {}

              await webViewController.clearCache();
              await cookieManager.clearCookies();

              Navigator.of(context).pop();
              widget.refresh();
            }
          },
          initialUrl: 'https://twitch.tv/login',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0",
        ),
      );
}
