import 'package:equatable/equatable.dart';

import '/data/twitch_account.dart';

abstract class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectionDisconnected extends ConnectionState {}

abstract class ConnectionStateWithCredentials extends ConnectionState {
  final TwitchAccount twitchAccount;

  ConnectionStateWithCredentials(this.twitchAccount);

  @override
  List<Object?> get props => [twitchAccount, ...super.props];
}

class ConnectionConnecting extends ConnectionStateWithCredentials {
  ConnectionConnecting(TwitchAccount credentials) : super(credentials);
}

class ConnectionConnected extends ConnectionStateWithCredentials {
  final List<String> blockedUserIds;

  ConnectionConnected(
    TwitchAccount credentials, {
    required this.blockedUserIds,
  }) : super(credentials) {
    print(blockedUserIds);
  }
}

class ConnectionReconnecting extends ConnectionStateWithCredentials {
  ConnectionReconnecting(TwitchAccount credentials) : super(credentials);
}

class ConnectionBanned extends ConnectionStateWithCredentials {
  ConnectionBanned(TwitchAccount credentials) : super(credentials);
}

class ConnectionInvalidCredentials extends ConnectionStateWithCredentials {
  ConnectionInvalidCredentials(TwitchAccount credentials) : super(credentials);
}
