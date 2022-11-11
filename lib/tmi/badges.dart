import 'package:bloc/bloc.dart';

import '../data/custom_badge.dart';

class Badges extends Cubit<List<CustomBadge>> {
  Badges() : super([]);

  void change(List<CustomBadge> badges) {
    emit(badges);
  }
}
