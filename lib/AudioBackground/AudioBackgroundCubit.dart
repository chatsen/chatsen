import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AudioBackgroundCubit extends Cubit<WebViewController?> {
  AudioBackgroundCubit() : super(null);

  void set(WebViewController controller) => emit(controller);
}
