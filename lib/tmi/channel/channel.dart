import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatsen/providers/emote_provider.dart';

import '../../data/emote.dart';
import '../client/client.dart';
import '../emotes.dart';
import '/tmi/channel/channel_event.dart';
import '/tmi/channel/channel_messages.dart';
import '/tmi/channel/channel_state.dart';
import '/tmi/channel/messages/channel_message_event.dart';
import '/tmi/channel/messages/channel_message_state_change.dart';

class Channel extends Bloc<ChannelEvent, ChannelState> {
  Client client;
  String? id;
  String name;
  Timer? suspensionTimer;
  ChannelMessages channelMessages = ChannelMessages();
  Emotes channelEmotes = Emotes();

  Channel({
    required this.client,
    required this.name,
  }) : super(ChannelDisconnected()) {
    on<ChannelJoin>((event, emit) async {
      emit(ChannelConnecting(receiver: event.receiver, transmitter: event.transmitter));
    });

    on<ChannelPart>((event, emit) async {
      emit(ChannelDisconnected());
    });

    on<ChannelConnect>((event, emit) async {
      if (state is! ChannelStateWithConnection) {
        return;
      }

      final realState = state as ChannelStateWithConnection;
      emit(ChannelConnected(receiver: realState.receiver, transmitter: realState.transmitter));
    });

    on<ChannelBan>((event, emit) async {
      if (state is! ChannelStateWithConnection) {
        return;
      }

      final realState = state as ChannelStateWithConnection;
      emit(ChannelBanned(receiver: realState.receiver, transmitter: realState.transmitter));
    });

    on<ChannelTimeout>((event, emit) async {
      if (state is! ChannelStateWithConnection) {
        return;
      }

      final realState = state as ChannelStateWithConnection;
      emit(ChannelBanned(receiver: realState.receiver, transmitter: realState.transmitter));
      suspensionTimer = Timer(event.duration, () {
        emit(realState);
      });
      // emit(ChannelConnected(receiver: realState.receiver, transmitter: realState.transmitter));
    });

    on<ChannelSuspend>((event, emit) async {
      if (state is! ChannelStateWithConnection) {
        return;
      }

      final realState = state as ChannelStateWithConnection;
      emit(ChannelSuspended(receiver: realState.receiver, transmitter: realState.transmitter));
    });
  }

  @override
  void onEvent(ChannelEvent event) {
    channelMessages.add(ChannelMessageEvent(channel: this, channelEvent: event, dateTime: DateTime.now()));
    super.onEvent(event);
  }

  @override
  void onChange(Change<ChannelState> change) {
    suspensionTimer?.cancel();
    suspensionTimer = null;

    channelMessages.add(ChannelMessageStateChange(channel: this, change: change, dateTime: DateTime.now()));
    super.onChange(change);
  }

  Future<void> send(String message) async {
    if (state is! ChannelStateWithConnection) {
      return;
    }

    final realState = state as ChannelStateWithConnection;
    realState.transmitter.send('PRIVMSG $name :$message');
  }

  Future<void> refreshEmotes() async {
    if (id == null) throw 'invalid channel id';

    final emotes = <Emote>[];
    final emoteProviders = client.providers.whereType<EmoteProvider>();
    for (final emoteProvider in emoteProviders) {
      try {
        emotes.addAll(await emoteProvider.channelEmotes(id!));
      } catch (e) {
        print('Couldn\'t get ${emoteProvider.name} channel emotes for $name ($id)');
      }
    }

    channelEmotes.emit(emotes);
  }
}
