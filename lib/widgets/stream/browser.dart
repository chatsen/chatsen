import 'package:chatsen/components/surface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/browser_state.dart';

class Browser extends StatelessWidget {
  final List<String> urls;

  const Browser({
    super.key,
    required this.urls,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: DefaultTabController(
        length: urls.length,
        child: TabBarView(
          children: [
            for (final channel in urls)
              WebView(
                initialUrl: channel, // ?? 'https://player.twitch.tv/?channel=forsen&enableExtensions=true&muted=true&parent=chatsen.app&player=popout&volume=1.0',
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
