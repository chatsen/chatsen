import 'package:flutter/material.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import '/MVP/Presenters/AccountPresenter.dart';
import '/Pages/OAuth.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

/// [AccountView] is our settings view that allows to change accounts. It uses the [AccountPresenter] to fetch and save a [AccountModel] model that contains our configuration.
class AccountView extends StatefulWidget {
  final twitch.Client? client;

  const AccountView({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Future? accounts;

  void refresh() async {
    accounts = AccountPresenter.loadData();
    setState(() {});
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: accounts,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                for (var account in snapshot.data)
                  ListTile(
                    title: Text(account.login),
                    subtitle: Text(account.token != null ? account.clientId : 'Anonymous Login'),
                    trailing: account.token != null
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              snapshot.data.remove(account);
                              AccountPresenter.saveData(snapshot.data);
                              setState(() {});
                            },
                          )
                        : null,
                    leading: (account.avatarBytes != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(128.0),
                            child: Image.memory(account.avatarBytes),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.account_circle, size: 48.0),
                          ),
                    onTap: () async {
                      widget.client!.swapCredentials(
                        twitch.Credentials(
                          clientId: account.clientId,
                          id: account.id,
                          login: account.login,
                          token: account.token,
                        ),
                      );
                      AccountPresenter.setCurrentAccount(account);
                      Navigator.of(context).pop();
                    },
                  ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.add, size: 32.0),
                  ),
                  title: Text('Add account'),
                  onTap: () async => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OAuthPage(
                        refresh: refresh,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator.adaptive();
        },
      );
}
