import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/browser/browser_tab.dart';

class Browser extends StatelessWidget {
  final List<BrowserTab> tabs;

  const Browser({
    super.key,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: DefaultTabController(
        length: tabs.length,
        child: TabBarView(
          children: [
            for (final tab in tabs)
              WebView(
                initialUrl: tab.url, // ?? 'https://player.twitch.tv/?channel=forsen&enableExtensions=true&muted=true&parent=chatsen.app&player=popout&volume=1.0',
                javascriptMode: JavascriptMode.unrestricted,
                allowsInlineMediaPlayback: true,
                userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
              ),
          ],
        ),
      ),
    );
  }
}

// Row(
//   children: [
//     Expanded(
//       child: TabBar(
//         tabs: [
//           for (final channel in browserState)
//             GestureDetector(
//               onLongPress: () {
//                 final browserState = BlocProvider.of<BrowserState>(context);
//                 browserState.emit(browserState.state.where((element) => element != channel).toList());
//               },
//               child: SizedBox(
//                 height: 48.0,
//                 child: Center(child: Text(channel)),
//               ),
//             ),
//         ],
//       ),
//     ),
//     Surface(
//       onTap: () {},
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Icon(Icons.add),
//       ),
//     ),
//   ],
// ),
