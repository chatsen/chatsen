import 'dart:io';

import 'package:chatsen/modal/components/modal_header.dart';
import 'package:chatsen/modal/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../components/tile.dart';
import '/tmi/client/client.dart';
import '/components/boxlistener.dart';
import '/components/modal.dart';
import '/components/separator.dart';
import '/data/twitch_account.dart';
import 'oauth_webview.dart';
import 'twitch_token_input.dart';
import 'twitch_account.dart';

class ChatsenModal extends StatelessWidget {
  const ChatsenModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BoxListener(
      box: Hive.box('AccountSettings'),
      builder: (context, accountSettingsBox) {
        return BoxListener(
          box: Hive.box('TwitchAccounts'),
          builder: (BuildContext context, Box twitchAccountsBox) {
            return ListView(
              shrinkWrap: true,
              children: [
                ModalHeader(
                  title: AppLocalizations.of(context)!.chatsen,
                  trailing: Tooltip(
                    message: AppLocalizations.of(context)!.settings,
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Modal.show(
                          context: context,
                          child: const SettingsModal(),
                        );
                      },
                      borderRadius: BorderRadius.circular(24.0),
                      child: const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Icon(Icons.settings_outlined),
                      ),
                    ),
                  ),
                ),
                if (accountSettingsBox.get('activeTwitchAccount') != null) ...[
                  TwitchAccountButton(
                    active: true,
                    // key: ObjectKey(twitchAccount),
                    twitchAccount: twitchAccountsBox.values.firstWhere((element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash, orElse: () => null),
                  ),
                  const Separator(),
                ],
                for (var twitchAccount in twitchAccountsBox.values.where((element) => accountSettingsBox.get('activeTwitchAccount') != element.tokenData.hash))
                  TwitchAccountButton(
                    // key: ObjectKey(twitchAccount),
                    twitchAccount: twitchAccount,
                  ),
                Tile(
                  onTap: () {
                    if (!Platform.isAndroid && !Platform.isIOS) {
                      Modal.show(
                        context: context,
                        child: const TwitchTokenInputModal(),
                      );
                      return;
                    }

                    Modal.show(
                      enableDrag: false,
                      context: context,
                      child: const OAuthWebViewModal(),
                    );
                  },
                  onLongPress: () {
                    Modal.show(
                      context: context,
                      child: const TwitchTokenInputModal(),
                    );
                  },
                  prefix: const Icon(Icons.person_add_alt),
                  title: AppLocalizations.of(context)!.addAnotherAccount,
                ),
                const Separator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.privacyPolicy,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(4.0),
                          child: const SizedBox(
                            height: 4.0,
                            width: 4.0,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.termsOfService,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TwitchAccountButton extends StatelessWidget {
  final TwitchAccount twitchAccount;
  final bool active;

  const TwitchAccountButton({
    super.key,
    required this.twitchAccount,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<Client>().connectAs(twitchAccount);

        var accountSettingsBox = Hive.box('AccountSettings');
        await accountSettingsBox.put('activeTwitchAccount', twitchAccount.tokenData.hash);

        await WebviewCookieManager().clearCookies();

        await WebviewCookieManager().setCookies([
          for (var cookie in twitchAccount.cookies ?? []) cookie.toCookie(),
        ]);
      },
      onLongPress: () {
        Modal.show(
          context: context,
          child: TwitchAccountModal(
            twitchAccount: twitchAccount,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(width: active ? 0.0 : 2.0),
            Material(
              borderRadius: BorderRadius.circular(24.0),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: active ? 40.0 : 36.0,
                height: active ? 40.0 : 36.0,
                child: twitchAccount.userData != null
                    ? Ink.image(
                        image: NetworkImage(twitchAccount.userData!.avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.question_mark_outlined),
              ),
            ),
            SizedBox(width: 16.0 + (active ? 0.0 : 2.0)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(twitchAccount.userData?.displayName ?? twitchAccount.tokenData.login),
                Text(
                  AppLocalizations.of(context)!.loggedInVia('Twitch'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
