import 'package:chatsen/tmi/channel/messages/channel_message_chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tmi/channel/channel_message.dart';

class NotificationsCubitState {
  final List<ChannelMessage> messages;
  final int unread;

  NotificationsCubitState({
    required this.messages,
    required this.unread,
  });

  NotificationsCubitState copyWith({
    List<ChannelMessage>? messages,
    int? unread,
  }) =>
      NotificationsCubitState(
        messages: messages ?? this.messages,
        unread: unread ?? this.unread,
      );
}

class NotificationsCubit extends Cubit<NotificationsCubitState> {
  NotificationsCubit() : super(NotificationsCubitState(messages: [], unread: 0));

  void add(ChannelMessage message) {
    if (state.messages.any((element) => element is ChannelMessageChat && message is ChannelMessageChat && element.id == message.id)) return;
    emit(state.copyWith(
      messages: [...state.messages, message],
      unread: state.unread + 1,
    ));
  }

  void clearUnreads() {
    emit(state.copyWith(unread: 0));
  }

  void clear() {
    emit(state.copyWith(messages: [], unread: 0));
  }
}
