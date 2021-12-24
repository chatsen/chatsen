import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import 'BlockedTerm.dart';

class BlockedTermsCubit extends Cubit<List<BlockedTerm>> {
  Box blockedTermsBox;

  BlockedTermsCubit(this.blockedTermsBox) : super([]) {
    refresh();
  }

  Future<void> refresh() async {

  }

  Future<void> add(BlockedTerm blockedTerm) async {
    emit([...state, blockedTerm]);
  }

  Future<void> remove(BlockedTerm blockedTerm) async {
    emit(state.where((term) => term != blockedTerm).toList());
  }

  Future<void> update(BlockedTerm blockedTerm, BlockedTerm replacement) async {
    emit(state.map((term) => term == blockedTerm ? replacement : term).toList());
  }
}
