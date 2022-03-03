import 'package:equatable/equatable.dart';

import '/data/twitch_account.dart';

class ConnectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectionConnect extends ConnectionEvent {
  final TwitchAccount twitchAccount;

  ConnectionConnect(this.twitchAccount);

  @override
  List<Object?> get props => [twitchAccount, ...super.props];
}

class ConnectionDisconnect extends ConnectionEvent {}

class ConnectionReconnect extends ConnectionEvent {
  final TwitchAccount? twitchAccount;

  ConnectionReconnect({
    this.twitchAccount,
  });

  @override
  List<Object?> get props => [twitchAccount, ...super.props];
}
