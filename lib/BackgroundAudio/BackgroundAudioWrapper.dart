import 'dart:io';

import 'package:chatsen/BackgroundDaemon/BackgroundDaemonCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BackgroundAudioWrapper extends StatefulWidget {
  final Widget child;

  const BackgroundAudioWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<BackgroundAudioWrapper> createState() => _BackgroundAudioWrapperState();

  // static WebViewController? getController(BuildContext context) => context.findAncestorStateOfType<_BackgroundAudioWrapperState>()!.webViewController;
}

class _BackgroundAudioWrapperState extends State<BackgroundAudioWrapper> {
  void setupLoop() async {
    await BlocProvider.of<BackgroundDaemonCubit>(context).loop(true);
    await Future.delayed(Duration(seconds: 2));
    await BlocProvider.of<BackgroundDaemonCubit>(context).loop(true);
    await Future.delayed(Duration(seconds: 8));
    await BlocProvider.of<BackgroundDaemonCubit>(context).loop(true);
  }

  @override
  void initState() {
    setupLoop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? Stack(
          children: [
            SizedBox(
              height: 0.0,
              child: WebView(
                onWebViewCreated: (controller) {
                  BlocProvider.of<BackgroundDaemonCubit>(context).emit(controller);
                },
                initialUrl: 'https://chatsen.app/assets/bgm.mp3',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (url) => setupLoop(),
              ),
            ),
            Positioned.fill(child: widget.child),
          ],
        )
      : widget.child;
}
