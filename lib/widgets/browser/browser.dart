import 'package:chatsen/tools/m3parser.dart';
import 'package:chatsen/tools/m3themes.dart';
import 'package:chatsen/widgets/browser/browser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/browser/browser_state.dart';
import '../../data/browser/browser_tab.dart';

class Browser extends StatelessWidget {
  final bool showTabs;

  const Browser({
    super.key,
    this.showTabs = false,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<BrowserState, List<BrowserTab>>(
        builder: (context, state) {
          return Theme(
            data: M3Parser.patchTheme(Theme.of(context)),
            child: Material(
              child: DefaultTabController(
                length: state.length,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          for (final tab in state) BrowserView(url: tab.url),
                        ],
                      ),
                    ),
                    if (showTabs)
                      TabBar(
                        isScrollable: true,
                        tabs: [
                          for (final tab in state)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                tab.name,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
