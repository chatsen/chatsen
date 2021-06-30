import 'package:bloc/bloc.dart';
import 'package:chatsen/Commands/Command.dart';

class CommandsCubit extends Cubit<List<Command>> {
  CommandsCubit()
      : super([
          Command(trigger: '/tuck', command: '/me tucks {1} to bed FeelsOkayMan {2+}'),
          Command(trigger: '/test3', command: '{2+} {1} z'),
          Command(trigger: '/ee', command: '{1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2} {1} {2}'),
          Command(trigger: '/kaomoji', command: '(⌐■_■) kaomoji users (⌐■_■) kaomoji users (⌐■_■) kaomoji users (⌐■_■) kaomoji users'),
          Command(trigger: '/dongers', command: 'ヽ༼ຈل͜ຈ༽ﾉ raise your dongersヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ raise your dongers'),
        ]);

  void add(Command cmd) => emit([...state, cmd]);
  void remove(Command cmd) => state.removeWhere((element) => element == cmd);
}
