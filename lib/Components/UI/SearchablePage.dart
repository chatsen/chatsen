import 'dart:io';

import 'package:flutter/material.dart';

import 'CustomSliverAppBarDelegate.dart';
import 'NoAppBarBlur.dart';

class SearchablePage extends StatelessWidget {
  final String title;
  final Widget searchPrefix;
  final String searchText;
  final Widget searchSuffix;
  final List<Widget> actions;
  final List<Widget> children;

  const SearchablePage({
    Key? key,
    required this.title,
    required this.searchPrefix,
    required this.searchText,
    required this.searchSuffix,
    required this.actions,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: NoAppBarBlur(),
        body: Builder(
          builder: (context) {
            var listChildren = [
              ...children,
              SizedBox(height: MediaQuery.of(context).padding.bottom),
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
                              Spacer(),
                              ...actions,
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Settings',
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                                    // controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search settings',
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                    // onChanged: (value) => setState(() {}),
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
