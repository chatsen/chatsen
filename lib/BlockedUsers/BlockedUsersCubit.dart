import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

class BlockedUsersCubit extends Cubit<List<String>> {
  Box blockedUsersBox;

  BlockedUsersCubit(this.blockedUsersBox) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    emit(List<String>.from(blockedUsersBox.values));
  }

  Future<void> add(String username) async {
    await blockedUsersBox.add(username);
    emit([...state, username]);
    // await refresh();
  }

  Future<void> remove(String username) async {
    var index = List<String>.from(blockedUsersBox.values).indexOf(username);
    await blockedUsersBox.deleteAt(index);
    emit(List<String>.from(state.where((u) => u != username)));
    // await refresh();
  }

  Future<void> replace(String old, String replacement) async {
    var index = List<String>.from(blockedUsersBox.values).indexOf(old);
    await blockedUsersBox.putAt(index, replacement);
    emit(List<String>.from(state.map((u) => u == old ? replacement : u)));
    // await refresh();
  }
}
