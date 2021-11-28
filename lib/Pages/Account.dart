import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chatsen/Accounts/AccountModel.dart';
import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:chatsen/Components/Modal/TokenModal.dart';
import 'package:chatsen/Components/UI/CustomSliverAppBarDelegate.dart';
import 'package:chatsen/Components/UI/NoAppBarBlur.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Pages/OAuth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:http/http.dart' as http;

class AccountPage extends StatefulWidget {
  final twitch.Client client;

  const AccountPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: InkWell(
          onLongPress: () async => TokenModal.show(
            context,
            client: widget.client,
          ),
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OAuthPage(
                  client: widget.client,
                ),
              ),
            ),
            // : () {},
            child: Icon(Icons.add),
          ),
        ),
        appBar: NoAppBarBlur(),
        body: BlocBuilder<AccountsCubit, List<AccountModel>>(
          builder: (context, state) {
            var listChildren = [
              for (var account in [AccountsCubit.defaultAccount, ...state].where((account) => account.login!.toLowerCase().contains(searchController.text.toLowerCase())))
                Tile(
                  leading: Padding(
                    padding: EdgeInsets.all(account.token != null ? 0.0 : 8.0),
                    child: account.token != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(128.0),
                            child: Image.memory(
                              account.avatarBytes!,
                              height: 32.0 + 8.0,
                            ),
                          )
                        : Icon((Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.question_circle : Icons.hide_source),
                  ),
                  trailing: account != AccountsCubit.defaultAccount
                      ? Padding(
                          padding: EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: Icon((Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.trash_fill : Icons.delete),
                            onPressed: () async {
                              if (account.isActive == true) {
                                await widget.client.swapCredentials(
                                  twitch.Credentials(
                                    clientId: AccountsCubit.defaultAccount.clientId,
                                    id: AccountsCubit.defaultAccount.id,
                                    login: AccountsCubit.defaultAccount.login!,
                                    token: AccountsCubit.defaultAccount.token,
                                  ),
                                );
                              }
                              await BlocProvider.of<AccountsCubit>(context).remove(account);
                            },
                          ),
                        )
                      : null,
                  title: account.token != null ? '${account.login}' : 'Anonymous User',
                  subtitle: !kDebugMode ? null : (account.token != null ? '${account.clientId}' : 'Login as ${account.login}'),
                  onTap: () async {
                    if (account.token == null) return;

                    var accountsCubit = BlocProvider.of<AccountsCubit>(context);
                    var navigator = Navigator.of(context);

                    var response = await http.get(
                      Uri.parse('https://id.twitch.tv/oauth2/validate'),
                      headers: {
                        'Authorization': 'Bearer ${account.token}',
                      },
                    );
                    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                    print('Verifying ${account.login} -> ${account.token} @ ${account.clientId}');
                    print(jsonResponse);

                    if (jsonResponse['expires_in'] != null && Duration(seconds: (jsonResponse['expires_in'] ?? -1)) <= Duration(days: 7)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Your login will expire soon! Please login again to refresh it.'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Re-login',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => OAuthPage(client: widget.client)),
                            );
                          },
                        ),
                      ));
                    }

                    if (jsonResponse['expires_in'] == null || (jsonResponse['expires_in'] ?? -1) < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Your login has expired! Please login again to refresh it.'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Re-login',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => OAuthPage(client: widget.client)),
                            );
                          },
                        ),
                      ));
                      return;
                    }

                    await widget.client.swapCredentials(
                      twitch.Credentials(
                        clientId: account.clientId,
                        id: account.id,
                        login: account.login!,
                        token: account.token,
                      ),
                    );
                    if (account.token != null) await accountsCubit.setActive(account);
                    if (navigator.canPop()) navigator.pop();
                  },
                ),
            ];

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 128.0 * 1.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.0),
                          Row(
                            children: [
                              // Container(
                              //   width: 24.0,
                              //   height: 24.0,
                              //   child: IconButton(
                              //     icon: Icon((Platform.isIOS || Platform.isMacOS) ? Icons.arrow_back_ios : Icons.arrow_back),
                              //     onPressed: () => Navigator.of(context).pop(),
                              //     padding: EdgeInsets.zero,
                              //     iconSize: 24.0,
                              //   ),
                              // ),
                              IconButton(
                                icon: Icon((Platform.isIOS || Platform.isMacOS) ? Icons.arrow_back_ios : Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                                padding: EdgeInsets.zero,
                                iconSize: 24.0,
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Accounts',
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  // pinned: true,
                  floating: true,
                  delegate: CustomSliverAppBarDelegate(
                    minHeight: 64.0 + MediaQuery.of(context).padding.top,
                    maxHeight: 64.0 + MediaQuery.of(context).padding.top,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Material(
                        borderRadius: BorderRadius.circular(64.0),
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search accounts',
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => listChildren[index],
                    childCount: listChildren.length,
                  ),
                ),
              ],
            );
          },
        ),
      );
}
