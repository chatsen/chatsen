import 'package:bloc/bloc.dart';

import '/data/badge.dart';

class Badges extends Cubit<List<Badge>> {
  Badges() : super([]);

  void change(List<Badge> badges) {
    emit(badges);
  }
}
