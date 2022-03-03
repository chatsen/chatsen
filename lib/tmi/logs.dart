import 'dart:math';

import 'package:bloc/bloc.dart';

import 'log.dart';

class Logs extends Cubit<List<Log>> {
  Logs() : super([]);

  void add(Log log) => emit([
        ...state.skip(max(0, state.length - 999)),
        log,
      ]);
}
