import 'package:flutter/material.dart';
import '/MVP/Views/AccountView.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

/// [AccountPage] is the Page scaffold representing our app's autocompletion settings. It allows changing the look and feel of autocompletion.
class AccountPage extends StatelessWidget {
  final twitch.Client? client;

  const AccountPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Accounts'),
        ),
        body: AccountView(
          client: client,
        ),
      );
}
