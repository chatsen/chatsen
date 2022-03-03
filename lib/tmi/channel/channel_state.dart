import 'package:equatable/equatable.dart';

import '../connection/connection.dart';

abstract class ChannelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChannelDisconnected extends ChannelState {}

abstract class ChannelStateWithConnection extends ChannelState {
  final Connection receiver;
  final Connection transmitter;

  ChannelStateWithConnection(this.receiver, this.transmitter);

  @override
  List<Object?> get props => [receiver, transmitter, ...super.props];
}

class ChannelConnecting extends ChannelStateWithConnection {
  ChannelConnecting({
    required Connection receiver,
    required Connection transmitter,
  }) : super(receiver, transmitter);
}

class ChannelConnected extends ChannelStateWithConnection {
  ChannelConnected({
    required Connection receiver,
    required Connection transmitter,
  }) : super(receiver, transmitter);
}

class ChannelSuspended extends ChannelStateWithConnection {
  ChannelSuspended({
    required Connection receiver,
    required Connection transmitter,
  }) : super(receiver, transmitter);
}

class ChannelBanned extends ChannelStateWithConnection {
  ChannelBanned({
    required Connection receiver,
    required Connection transmitter,
  }) : super(receiver, transmitter);
}
