import 'dart:math';

import 'package:chatsen/Accounts/AccountModel.dart';
import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Pages/OAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class AccountPage extends StatefulWidget {
  final twitch.Client client;

  const AccountPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OAuthPage())),
          child: Icon(Icons.add),
        ),
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
                        : Icon(Icons.hide_source),
                  ),
                  trailing: account.token != null
                      ? Padding(
                          padding: EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              if (account.isActive == true) {
                                widget.client.swapCredentials(
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
                  subtitle: account.token != null ? '${account.clientId}' : 'Login as ${account.login}',
                  onTap: () async {
                    widget.client.swapCredentials(
                      twitch.Credentials(
                        clientId: account.clientId,
                        id: account.id,
                        login: account.login!,
                        token: account.token,
                      ),
                    );
                    if (account.token != null) await BlocProvider.of<AccountsCubit>(context).setActive(account);
                    Navigator.of(context).pop();
                  },
                ),
            ];

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 128.0 * 1.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.0),
                          Container(
                            width: 24.0,
                            height: 24.0,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                              padding: EdgeInsets.zero,
                              iconSize: 24.0,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Accounts',
                            style: Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
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
                  delegate: _SliverAppBarDelegate(
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
