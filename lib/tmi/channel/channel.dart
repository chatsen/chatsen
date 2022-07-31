import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatsen/tmi/channel/channel_chatters.dart';

import '../../api/chatsen/chatsen.dart';
import '../../data/badge.dart';
import '../../data/emote.dart';
import '../client/client.dart';
import '../emotes.dart';
import '/tmi/channel/channel_event.dart';
import '/tmi/channel/channel_messages.dart';
import '/tmi/channel/channel_state.dart';
import '/tmi/channel/messages/channel_message_event.dart';
import '/tmi/channel/messages/channel_message_state_change.dart';
import '/providers/badge_provider.dart';
import '/providers/emote_provider.dart';
import '/tmi/badges.dart';
import '/tmi/channel/channel_info.dart';
import 'messages/channel_message_chat.dart';

class Channel extends Bloc<ChannelEvent, ChannelState> {
  Client client;
  String? id;
  String name;
  Timer? suspensionTimer;
  ChannelMessages channelMessages = ChannelMessages();
  Emotes channelEmotes = Emotes();
  Badges channelBadges = Badges();
  ChannelInfo channelInfo = ChannelInfo();
  ChannelChatters channelChatters = ChannelChatters();

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

  Future<void> send(
    String message, {
    Map<String, String>? tags,
  }) async {
    if (state is! ChannelStateWithConnection) {
      return;
    }

    var ircMessageToSend = 'PRIVMSG $name :$message';
    if (tags != null) {
      ircMessageToSend = '@${tags.entries.map((entry) => '${entry.key}=${entry.value}').join(';')} $ircMessageToSend';
    }

    final replacement = String.fromCharCodes(Runes('\u{e0002}'));
    final zeroWidthJoiner = String.fromCharCodes(Runes('\u{200d}'));
    message = message.replaceAll(replacement, zeroWidthJoiner);

    final realState = state as ChannelStateWithConnection;
    realState.transmitter.send(ircMessageToSend);
  }

  Future<void> refresh() async {
    final emotesFuture = refreshEmotes();
    final badgesFuture = refreshBadges();
    final refreshChannelFuture = refreshChannelUser();
    final refreshChattersFuture = refreshChannelChatters();

    await Future.wait([emotesFuture, badgesFuture]);

    for (final message in channelMessages.state.whereType<ChannelMessageChat>()) {
      message.build();
    }
    channelMessages.emit([...channelMessages.state]);

    await Future.wait([refreshChannelFuture, refreshChattersFuture]);
  }

  Future<void> refreshEmotes() async {
    if (id == null) throw 'invalid channel id';

    final emotes = <Emote>[];
    final emoteProviders = client.providers.whereType<EmoteProvider>();
    for (final emoteProvider in emoteProviders) {
      try {
        emotes.addAll(await emoteProvider.channelEmotes(id!));
      } catch (e) {
        log('Couldn\'t get ${emoteProvider.name} channel emotes for $name ($id)');
      }
    }

    channelEmotes.emit(emotes);
  }

  Future<void> refreshBadges() async {
    if (id == null) throw 'invalid channel id';

    final badges = <Badge>[];
    final badgeProviders = client.providers.whereType<BadgeProvider>();
    for (final badgeProvider in badgeProviders) {
      try {
        badges.addAll(await badgeProvider.channelBadges(id!));
      } catch (e) {
        log('Couldn\'t get ${badgeProvider.name} channel badges for $name ($id)');
      }
    }

    channelBadges.emit(badges);
  }

  Future<void> refreshChannelUser() async {
    try {
      channelInfo.emit(await Chatsen.user(name.replaceFirst('#', '')));
    } catch (e) {
      log('Couldn\'t get channel info for $name');
    }
  }

  Future<void> refreshChannelChatters() async {
    try {
      channelChatters.emit((await Chatsen.userWithViewers(name.replaceFirst('#', ''))).channel?.chatters);
    } catch (e) {
      log('Couldn\'t get channel chatters for $name');
    }
  }
}
