import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

import '../../data/twitch_account.dart';
import '/irc/message.dart' as irc;
import 'connection_event.dart';
import '/tmi/log.dart';
import '/tmi/logs.dart';
import 'connection_state.dart';

class Connection extends Bloc<ConnectionEvent, ConnectionState> {
  /// Interval for websocket level ping frames. `dart:io` closes the socket when
  /// a ping is not answered by a pong within the same interval, which is the
  /// only thing that detects a socket the peer silently dropped (iOS suspending
  /// the app, a wifi/cellular handover, a NAT timeout). Without it such a socket
  /// stays "open" forever and neither onDone nor onError ever fires.
  static const pingInterval = Duration(seconds: 30);
  static const connectTimeout = Duration(seconds: 15);
  static const reconnectDelay = Duration(seconds: 4);

  /// A socket whose peer is gone never completes its closing handshake, so the
  /// teardown of the previous connection is never awaited unbounded.
  static const closeTimeout = Duration(seconds: 2);

  /// How long a connection may stay silent before [healthCheck] treats it as
  /// dead. Twitch pings every ~5 minutes, and our own pings keep the socket
  /// busy well below this, so any longer gap means traffic stopped flowing.
  static const stallTimeout = Duration(minutes: 1);

  IOWebSocketChannel? channel;
  StreamSubscription<dynamic>? subscription;
  Function(Connection connection, ConnectionEvent event)? onEventTrigger;
  Function(Connection connection, Change<ConnectionState> change)? onStateChange;
  Function(Connection connection, irc.Message event)? onReceive;
  TwitchAccount? get twitchAccount => (state is ConnectionStateWithCredentials) ? (state as ConnectionStateWithCredentials).twitchAccount : null;
  Logs logs = Logs();

  /// Incremented for every [connect] call. Callbacks belonging to an older
  /// socket compare against it and bail out, so an orphaned socket can never
  /// schedule a reconnect for the socket that replaced it.
  int _generation = 0;
  bool _closed = false;

  /// Timestamp of the last message read off the socket, used by [healthCheck].
  DateTime? lastReceivedAt;

  @override
  void onEvent(ConnectionEvent event) {
    logs.add(Log(data: event));
    onEventTrigger?.call(this, event);
    super.onEvent(event);
  }

  @override
  void onChange(Change<ConnectionState> change) {
    logs.add(Log(data: change));
    onStateChange?.call(this, change);
    super.onChange(change);
  }

  Connection() : super(ConnectionDisconnected()) {
    on<ConnectionConnect>((event, emit) async {
      emit(ConnectionConnecting(event.twitchAccount));
      await connect(
        nick: event.twitchAccount.tokenData.login,
        pass: event.twitchAccount.tokenData.accessToken != null ? 'oauth:${event.twitchAccount.tokenData.accessToken}' : null,
      );
    });

    on<ConnectionDisconnect>((event, emit) async {
      await cancel();
      emit(ConnectionDisconnected());
    });

    on<ConnectionReconnect>((event, emit) async {
      if (event.twitchAccount == null && state is! ConnectionStateWithCredentials) return;
      add(ConnectionConnect(event.twitchAccount ?? (state as ConnectionStateWithCredentials).twitchAccount));
    });
  }

  Future<void> connect({
    String? nick,
    String? pass,
  }) async {
    final generation = ++_generation;
    await cancel();

    // A newer connect() overtook us while the old socket was being torn down.
    if (_closed || generation != _generation) return;

    final socket = IOWebSocketChannel.connect(
      Uri.parse('wss://irc-ws.chat.twitch.tv:443'),
      pingInterval: pingInterval,
      connectTimeout: connectTimeout,
    );
    channel = socket;

    subscription = socket.stream.listen(
      (event) async {
        for (final singleEvent in event.trim().split('\r\n').where((String singleEvent) => singleEvent.isNotEmpty).map((String singleEvent) => singleEvent.trim())) {
          final message = irc.Message.fromEvent(singleEvent);
          receive(message);
        }
      },
      onDone: () => scheduleReconnect(generation),
      onError: (error) => scheduleReconnect(generation),
      // Without this the stream reports the error and *then* closes, so both
      // onError and onDone schedule a reconnect. Every failed attempt would
      // then double the number of pending reconnects until Twitch rate limits
      // the client and nothing gets back online at all.
      cancelOnError: true,
    );

    send('CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
    if (pass != null) send('PASS $pass');
    send('NICK ${nick ?? 'justinfan6969'}');
  }

  /// Requests a reconnect for the socket identified by [generation], unless it
  /// has already been replaced or this connection has been closed.
  Future<void> scheduleReconnect(int generation, {Duration delay = reconnectDelay}) async {
    if (_closed || generation != _generation) return;
    await Future.delayed(delay);
    if (_closed || generation != _generation) return;
    add(ConnectionReconnect());
  }

  Future<void> send(String message) async {
    try {
      if (channel == null) throw 'not connected';
      logs.add(Log(data: irc.Message.fromEvent(message), outgoing: true));
      channel?.sink.add(message);
    } catch (e) {
      logs.add(Log(data: e));
    }
  }

  /// Reconnects when the socket looks dead. Called when the app returns from
  /// the background: iOS tears down sockets of suspended apps without ever
  /// notifying the app, so on resume the channel can look connected while no
  /// traffic will ever reach it again.
  Future<void> healthCheck() async {
    if (_closed || state is! ConnectionStateWithCredentials) return;

    final last = lastReceivedAt;
    final alive = state is ConnectionConnected && last != null && DateTime.now().difference(last) < stallTimeout;
    if (alive) return;

    await scheduleReconnect(_generation, delay: Duration.zero);
  }

  Future<void> receive(irc.Message event) async {
    try {
      lastReceivedAt = DateTime.now();
      logs.add(Log(data: event));
      onReceive?.call(this, event);
      if (event.command == 'PING') {
        await send('PONG :${event.parameters.join(' ')}');
      } else if (event.command == 'RECONNECT') {
        // Twitch is about to drop this connection for maintenance.
        await scheduleReconnect(_generation, delay: Duration.zero);
      }
    } catch (e) {
      logs.add(Log(data: e));
    }
  }

  Future<void> cancel() async {
    final oldSubscription = subscription;
    final oldChannel = channel;
    subscription = null;
    channel = null;

    await oldSubscription?.cancel().timeout(closeTimeout, onTimeout: () {});
    final close = oldChannel?.sink.close();
    if (close != null) await close.timeout(closeTimeout, onTimeout: () => null);
  }

  @override
  Future<void> close() async {
    _closed = true;
    await cancel();
    return super.close();
  }
}
