import 'package:bloc/bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BackgroundDaemonCubit extends Cubit<WebViewController?> {
  BackgroundDaemonCubit() : super(null);

  void receive(WebViewController wvController) => emit(wvController);

  void enable() => state?.loadUrl('https://chatsen.app/assets/bgm.mp3');
  void disable() => state?.loadUrl('https://chatsen.app/');

  Future<String?> evaluate(String js) async => await state?.evaluateJavascript(js);

  Future<void> play() async => evaluate('''
    [...document.querySelectorAll('audio, video')].forEach(el => el.play());
  ''');

  Future<void> pause() async => evaluate('''
    [...document.querySelectorAll('audio, video')].forEach(el => el.pause());
  ''');

  Future<void> loop(bool loop) async => evaluate('''
    [...document.querySelectorAll('audio, video')].forEach(el => el.loop = ${loop ? 'true' : 'false'});
  ''');
}
