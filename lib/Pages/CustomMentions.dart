import 'dart:io';

import 'package:chatsen/Components/Modal/CustomMentionModal.dart';
import 'package:chatsen/Components/UI/CustomSliverAppBarDelegate.dart';
import 'package:chatsen/Components/UI/NoAppBarBlur.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Mentions/CustomMention.dart';
import 'package:chatsen/Mentions/CustomMentionsCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomMentionsPage extends StatefulWidget {
  const CustomMentionsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomMentionsPage> createState() => _CustomMentionsPageState();
}

class _CustomMentionsPageState extends State<CustomMentionsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => CustomMentionModal.show(context),
          child: Icon(Icons.add),
        ),
        appBar: NoAppBarBlur(),
        body: BlocBuilder<CustomMentionsCubit, List<CustomMention>>(
          builder: (context, state) {
            var listChildren = [
              for (var customMention in state.where((x) => x.pattern.toLowerCase().contains(searchController.text.toLowerCase())))
                Tile(
                  // leading: Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Icon(Icons.hide_source),
                  // ),
                  trailing: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async => await BlocProvider.of<CustomMentionsCubit>(context).remove(customMention),
                    ),
                  ),
                  title: customMention.pattern,
                  // title: command.trigger,
                  // subtitle: command.command,
                  // onTap: () async => await CommandModal.show(
                  //   context,
                  //   command: command,
                  // ),
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
                            'Mentions',
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
                                      hintText: 'Search custom mentions',
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
