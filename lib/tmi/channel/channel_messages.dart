import 'dart:math';

import 'package:bloc/bloc.dart';

import 'channel_message.dart';
import 'messages/channel_message_id.dart';

class ChannelMessages extends Cubit<List<ChannelMessage>> {
  ChannelMessages() : super([]);

  static List<ChannelMessage> sort(List<ChannelMessage> messages) => messages..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  void add(ChannelMessage message) {
    if (message is ChannelMessageId && state.whereType<ChannelMessageId>().any((e) => e.id == (message as ChannelMessageId).id)) return;
    emit(
      sort([
        ...state.skip(max(0, state.length - 999)),
        message,
      ]),
    );
  }
}
