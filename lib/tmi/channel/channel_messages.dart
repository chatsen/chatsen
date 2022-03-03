import 'dart:math';

import 'package:bloc/bloc.dart';

import 'channel_message.dart';

class ChannelMessages extends Cubit<List<ChannelMessage>> {
  ChannelMessages() : super([]);

  static List<ChannelMessage> sort(List<ChannelMessage> messages) => messages..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  void add(ChannelMessage message) => emit(
        sort([
          ...state.skip(max(0, state.length - 999)),
          message,
        ]),
      );
}
