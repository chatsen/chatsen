import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/Components/Notification.dart';
import 'AudioBackground/AudioBackgroundCubit.dart';
import 'Pages/Home.dart';
import 'Settings/Settings.dart';
import 'Settings/SettingsState.dart';
import 'Theme/ThemeBloc.dart';
import 'Theme/ThemeManager.dart';
import 'Theme/ThemeState.dart';

/// Our [App] class. It represents our MaterialApp and will redirect us to our app's homepage.
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) => BlocBuilder<Settings, SettingsState>(
        builder: (context, settingsState) => BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            if (themeState is ThemeLoaded && settingsState is SettingsLoaded) {
              return MaterialApp(
                darkTheme: ThemeManager.buildTheme(Brightness.dark, themeState.colorScheme),
                theme: ThemeManager.buildTheme(Brightness.light, themeState.colorScheme),
                themeMode: themeState.mode,
                debugShowCheckedModeBanner: false,
                home: NotificationWrapper(
                  child: Builder(
                    builder: (context) => ThemeManager.routeWrapper(
                      context: context,
                      child: Column(
                        children: [
                          // SafeArea(
                          //   child: SizedBox(
                          //     height: 0.0,
                          //     child: WebView(
                          //         onWebViewCreated: (controller) {
                          //           webViewController = controller;
                          //           BlocProvider.of<AudioBackgroundCubit>(context).set(webViewController);
                          //         },
                          //         initialUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                          //         javascriptMode: JavascriptMode.unrestricted,
                          //         onPageFinished: (url) {
                          //           webViewController.evaluateJavascript('''
                          //             [...document.querySelectorAll('audio, video')].forEach(el => el.loop = true);
                          //           ''');
                          //         }),
                          //   ),
                          // ),
                          // OutlinedButton(
                          //   child: Text('hi'),
                          //   onPressed: () {
                          //     webViewController.evaluateJavascript('''
                          //           [...document.querySelectorAll('audio, video')].forEach(el => el.muted = true);
                          //           [...document.querySelectorAll('audio, video')].forEach(el => el.playbackRate = 90);
                          //           [...document.querySelectorAll('audio, video')].forEach(el => el.loop = true);
                          //           ''');
                          //   },
                          // ),
                          SizedBox(
                            height: 0.0,
                            child: WebView(
                                onWebViewCreated: (controller) {
                                  webViewController = controller;
                                  BlocProvider.of<AudioBackgroundCubit>(context).set(webViewController);
                                },
                                initialUrl: 'https://files.catbox.moe/gaydej.mp3',
                                javascriptMode: JavascriptMode.unrestricted,
                                onPageFinished: (url) {
                                  webViewController.evaluateJavascript('''
                                      [...document.querySelectorAll('audio, video')].forEach(el => el.loop = true);
                                    ''');
                                }),
                          ),
                          // https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
                          Expanded(child: HomePage()),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      );
}
