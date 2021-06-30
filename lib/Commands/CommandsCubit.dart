import 'package:bloc/bloc.dart';
import 'package:chatsen/Commands/Command.dart';
import 'package:hive/hive.dart';

class CommandsCubit extends Cubit<List<Command>> {
  final Box commandsBox;

  CommandsCubit(this.commandsBox)
      : super([
          Command(trigger: '/tuck', command: '/me tucks {1} to bed FeelsOkayMan {2+}'),
          // Command(trigger: '/test3', command: '{2+} {1} z'),
          Command(trigger: '/ee', command: '{1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2}'),
          Command(trigger: '/kaomoji', command: '(⌐■_■) kaomoji users (⌐■_■) kaomoji users (⌐■_■) kaomoji users (⌐■_■) kaomoji users'),
          Command(trigger: '/dongers', command: 'ヽ༼ຈل͜ຈ༽ﾉ raise your dongersヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers'),
        ]) {
    load();
  }

  Future<void> load() async {
    // emit(List<Command>.from(commandsBox.values));
  }

  Future<void> add(Command cmd) async {
    // await commandsBox.add(cmd);
    emit([...state, cmd]);
  }

  Future<void> remove(Command cmd) async {
    // await commandsBox.delete(cmd);
    state.removeWhere((element) => element == cmd);
    emit([...state]);
  }
}
