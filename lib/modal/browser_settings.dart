import 'package:chatsen/components/tile.dart';
import 'package:chatsen/data/browser/browser_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/browser/browser_state.dart';
import 'components/modal_header.dart';

class BrowserSettingsModal extends StatelessWidget {
  const BrowserSettingsModal({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<BrowserState, List<BrowserTab>>(
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            children: [
              const ModalHeader(title: 'Browser/Stream Settings'),
              for (final tab in state)
                Tile(
                  prefix: Icon(Icons.web_asset),
                  suffix: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () {
                      final browserState = BlocProvider.of<BrowserState>(context);
                      browserState.emit([
                        ...browserState.state.where((e) => e != tab),
                      ]);
                    },
                    child: const Icon(Icons.delete_forever_rounded),
                  ),
                  title: tab.name,
                ),
              Tile(
                title: 'Add page',
                prefix: const Icon(Icons.add),
                onTap: () async {},
              ),
            ],
          );
        },
      );
}
