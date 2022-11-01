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
  IOWebSocketChannel? channel;
  StreamSubscription<dynamic>? subscription;
  Function(Connection connection, ConnectionEvent event)? onEventTrigger;
  Function(Connection connection, Change<ConnectionState> change)? onStateChange;
  Function(Connection connection, irc.Message event)? onReceive;
  TwitchAccount? get twitchAccount => (state is ConnectionStateWithCredentials) ? (state as ConnectionStateWithCredentials).twitchAccount : null;
  Logs logs = Logs();

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
      await close();
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
    await cancel();
    channel = IOWebSocketChannel.connect(Uri.parse('wss://irc-ws.chat.twitch.tv:443'));

    subscription = channel?.stream.listen(
      (event) async {
        for (final singleEvent in event.trim().split('\r\n').where((String singleEvent) => singleEvent.isNotEmpty).map((String singleEvent) => singleEvent.trim())) {
          final message = irc.Message.fromEvent(singleEvent);
          receive(message);
        }
      },
      onDone: () async {
        await Future.delayed(const Duration(seconds: 4));
        add(ConnectionReconnect());
      },
      onError: (error) async {
        await Future.delayed(const Duration(seconds: 4));
        add(ConnectionReconnect());
      },
      // cancelOnError: true,
    );

    send('CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership');
    if (pass != null) send('PASS $pass');
    send('NICK ${nick ?? 'justinfan6969'}');
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

  Future<void> receive(irc.Message event) async {
    try {
      logs.add(Log(data: event));
      onReceive?.call(this, event);
      if (event.command == 'PING') {
        await send('PONG :${event.parameters.join(' ')}');
      }
    } catch (e) {
      logs.add(Log(data: e));
    }
  }

  Future<void> cancel() async {
    await subscription?.cancel();
    await channel?.sink.close();
  }
}
