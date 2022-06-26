import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelMessageEmbedsCubit extends Cubit<List<dynamic>> {
  ChannelMessageEmbedsCubit() : super([]);

  void clear() {
    emit([]);
  }

  void add(dynamic e) {
    emit([...state, e]);
  }

  bool get hasEmbeds => state.isNotEmpty;
}

mixin ChannelMessageEmbeds {
  ChannelMessageEmbedsCubit embeds = ChannelMessageEmbedsCubit();
}
