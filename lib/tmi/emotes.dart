import 'package:bloc/bloc.dart';

import '/data/emote.dart';

class Emotes extends Cubit<List<Emote>> {
  Emotes() : super([]);

  void change(List<Emote> emotes) {
    emit(emotes);
  }
}
