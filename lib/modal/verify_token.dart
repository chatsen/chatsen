import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/api/twitch/twitch.dart';
import 'verify_user.dart';
import '/components/modal.dart';
import '/data/twitch/token_data.dart';
import '/data/webview/cookie_data.dart';

class VerifyTokenModal extends StatefulWidget {
  final String token;
  final List<CookieData>? cookies;

  const VerifyTokenModal({
    super.key,
    required this.token,
    required this.cookies,
  });

  @override
  State<VerifyTokenModal> createState() => _VerifyTokenModalState();
}

class _VerifyTokenModalState extends State<VerifyTokenModal> {
  late Future<TokenData> future;

  @override
  void initState() {
    future = Twitch.validateToken(widget.token);
    future.then(
      (value) async {
        Navigator.of(context).pop();

        Modal.show(
          context: context,
          child: VerifyUserModal(
            tokenData: value,
            cookies: widget.cookies,
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<TokenData>(
          future: future,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (snapshot.hasData) ...[
                  Icon(
                    Icons.check,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.verifiedUserToken),
                  Text(AppLocalizations.of(context)!.loggedInAs('${snapshot.data!.login} (${snapshot.data!.userId})')),
                ],
                if (snapshot.hasError) ...[
                  Icon(
                    Icons.block,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.anErrorHasOccuredWhenVerifyingUserToken),
                  Text('${snapshot.error}'),
                ],
                if (!snapshot.hasData && !snapshot.hasError) ...[
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.verifyingUserToken),
                ],
              ],
            );
          },
        ),
      );
}
