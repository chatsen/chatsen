import 'package:bloc/bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class MentionsCubit extends Cubit<List<twitch.Message>> {
  MentionsCubit() : super([]);

  void add(twitch.Message message) => emit([...state, message]);
}
