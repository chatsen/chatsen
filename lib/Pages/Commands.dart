import 'dart:io';
import 'dart:math';

import 'package:chatsen/Accounts/AccountModel.dart';
import 'package:chatsen/Accounts/AccountsCubit.dart';
import 'package:chatsen/Commands/Command.dart';
import 'package:chatsen/Commands/CommandsCubit.dart';
import 'package:chatsen/Components/Modal/CommandModal.dart';
import 'package:chatsen/Components/UI/NoAppBarBlur.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Pages/OAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class CommandsPage extends StatefulWidget {
  const CommandsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CommandsPage> createState() => _CommandsPageState();
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

class _CommandsPageState extends State<CommandsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => CommandModal.show(context),
          child: Icon(Icons.add),
        ),
        appBar: NoAppBarBlur(),
        body: BlocBuilder<CommandsCubit, List<Command>>(
          builder: (context, state) {
            var listChildren = [
              for (var command in state.where((x) => x.command.toLowerCase().contains(searchController.text.toLowerCase()) || x.trigger.toLowerCase().contains(searchController.text.toLowerCase())))
                Tile(
                  // leading: Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Icon(Icons.hide_source),
                  // ),
                  trailing: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async => await BlocProvider.of<CommandsCubit>(context).remove(command),
                    ),
                  ),
                  title: command.trigger,
                  subtitle: command.command,
                  onTap: () async => await CommandModal.show(
                    context,
                    command: command,
                  ),
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
                              icon: Icon((Platform.isIOS || Platform.isMacOS) ? Icons.arrow_back_ios : Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                              padding: EdgeInsets.zero,
                              iconSize: 24.0,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Commands',
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
                                      hintText: 'Search commands',
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
