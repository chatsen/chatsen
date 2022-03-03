import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/components/separator.dart';
import 'verify_token.dart';
import '/components/modal.dart';
import '../data/twitch_account.dart';

class TwitchAccountModal extends StatelessWidget {
  final TwitchAccount twitchAccount;

  const TwitchAccountModal({
    Key? key,
    required this.twitchAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(24.0),
                  child: const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.close),
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.account,
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 40.0,
                  height: 40.0,
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(128.0),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 64.0 * 1.5,
                  height: 64.0 * 1.5,
                  child: twitchAccount.userData != null
                      ? Ink.image(
                          image: NetworkImage(twitchAccount.userData!.avatarUrl),
                        )
                      : const Icon(Icons.question_mark_outlined),
                ),
              ),
            ),
          ),
          SelectableText(
            twitchAccount.userData?.displayName ?? twitchAccount.tokenData.login,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          SelectableText(
            '${twitchAccount.tokenData.login}#${twitchAccount.tokenData.userId}',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Separator(),
          InkWell(
            onTap: () async {
              Navigator.of(context).pop();

              Modal.show(
                context: context,
                child: VerifyTokenModal(
                  token: '${twitchAccount.tokenData.accessToken}',
                  cookies: twitchAccount.cookies,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.refreshAccount,
                        // style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ExpirationText(twitchAccount: twitchAccount),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await twitchAccount.delete();
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.delete_forever_outlined),
                  ),
                  const SizedBox(width: 16.0),
                  Text(AppLocalizations.of(context)!.removeAccount),
                ],
              ),
            ),
          ),
        ],
      );
}

class ExpirationText extends StatefulWidget {
  const ExpirationText({
    Key? key,
    required this.twitchAccount,
  }) : super(key: key);

  final TwitchAccount twitchAccount;

  @override
  State<ExpirationText> createState() => _ExpirationTextState();
}

class _ExpirationTextState extends State<ExpirationText> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (Timer t) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.twitchAccount.tokenData.expiresAt != null ? AppLocalizations.of(context)!.expiresIn('${widget.twitchAccount.tokenData.expiresAt?.difference(DateTime.now())}') : AppLocalizations.of(context)!.expiresNever,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
      ),
      // style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
