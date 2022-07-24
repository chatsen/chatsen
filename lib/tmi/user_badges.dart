import 'package:bloc/bloc.dart';

import '../data/badge_users.dart';

class UserBadges extends Cubit<List<BadgeUsers>> {
  UserBadges() : super([]);

  void change(List<BadgeUsers> badges) {
    emit(badges);
  }
}
