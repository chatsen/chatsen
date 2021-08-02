import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import 'CustomMention.dart';

class CustomMentionsCubit extends Cubit<List<CustomMention>> {
  final Box commandsBox;

  CustomMentionsCubit(this.commandsBox) : super([]) {
    load();
  }

  Future<void> load() async {
    emit(List<CustomMention>.from(commandsBox.values));
  }

  Future<void> add(CustomMention cm) async {
    await commandsBox.add(cm);
    emit([...state, cm]);
  }

  Future<void> remove(CustomMention cm) async {
    await cm.delete();
    state.removeWhere((element) => element == cm);
    emit([...state]);
  }

  Future<void> update(CustomMention cm) async {
    await cm.save();
    emit([...state]);
  }
}
