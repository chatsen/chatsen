import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import '/data/twitch_account.dart';
import '/data/webview/cookie_data.dart';
import '/api/twitch/twitch.dart';

class VerifyUserModal extends StatefulWidget {
  final TokenData tokenData;
  final List<CookieData>? cookies;

  const VerifyUserModal({
    super.key,
    required this.tokenData,
    required this.cookies,
  });

  @override
  State<VerifyUserModal> createState() => _VerifyUserModalState();
}

class _VerifyUserModalState extends State<VerifyUserModal> {
  late Future<UserData> future;

  @override
  void initState() {
    future = Twitch.userData(widget.tokenData);
    future.then(
      (value) async {
        await Hive.box('TwitchAccounts').put(
          widget.tokenData.hash,
          TwitchAccount(
            tokenData: widget.tokenData,
            userData: value,
            cookies: widget.cookies,
          ),
        );

        Navigator.of(context).pop();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<UserData>(
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
                  // TODO: Display both background and avatar
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.verifiedUserData),
                  Text(AppLocalizations.of(context)!.loggedInAs(snapshot.data!.displayName)),
                ],
                if (snapshot.hasError) ...[
                  Icon(
                    Icons.block,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.anErrorHasOccuredWhenVerifyingUserData),
                  Text('${snapshot.error}'),
                ],
                if (!snapshot.hasData && !snapshot.hasError) ...[
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.verifyingUserData),
                ],
              ],
            );
          },
        ),
      );
}
