import 'package:bloc/bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BackgroundDaemonCubit extends Cubit<WebViewController?> {
  BackgroundDaemonCubit() : super(null);

  void receive(WebViewController wvController) => emit(wvController);

  void enable() => state?.loadRequest(Uri.parse('https://chatsen.app/assets/bgm.mp3'));
  void disable() => state?.loadRequest(Uri.parse('https://chatsen.app/'));

  Future<Object?> evaluate(String js) async => await state?.runJavaScriptReturningResult(js);

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
