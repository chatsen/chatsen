import 'dart:io';

import '/Components/Modal/BlockedUserModal.dart';
import '/Components/Modal/CustomMentionModal.dart';
import '/Components/UI/CustomSliverAppBarDelegate.dart';
import '/Components/UI/NoAppBarBlur.dart';
import '/Components/UI/Tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BlockedTerms/BlockedTerm.dart';
import '../BlockedTerms/BlockedTermsCubit.dart';
import '../Components/Modal/BlockedTermModal.dart';

class BlockedTermsPage extends StatefulWidget {
  const BlockedTermsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BlockedTermsPage> createState() => _BlockedTermsPageState();
}

class _BlockedTermsPageState extends State<BlockedTermsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => BlockedTermModal.show(context),
          child: Icon(Icons.add),
        ),
        appBar: NoAppBarBlur(),
        body: BlocBuilder<BlockedTermsCubit, List<BlockedTerm>>(
          builder: (context, state) {
            var listChildren = [
              for (var blockedTerm in state.where((x) => x.pattern.toLowerCase().contains(searchController.text.toLowerCase())))
                Tile(
                  trailing: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: IconButton(
                      icon: Icon((Platform.isMacOS || Platform.isIOS) ? CupertinoIcons.trash_fill : Icons.delete),
                      onPressed: () async => await BlocProvider.of<BlockedTermsCubit>(context).remove(blockedTerm),
                    ),
                  ),
                  title: blockedTerm.pattern,
                  onTap: () async => BlockedTermModal.show(
                    context,
                    blockedTerm: blockedTerm,
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
                            'Blocked terms',
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                                      hintText: 'Search blocked terms',
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
