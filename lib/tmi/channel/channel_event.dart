import 'package:equatable/equatable.dart';

import '../connection/connection.dart';

abstract class ChannelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChannelPart extends ChannelEvent {}

class ChannelJoin extends ChannelEvent {
  final Connection receiver;
  final Connection transmitter;

  ChannelJoin(this.receiver, this.transmitter);

  @override
  List<Object?> get props => [receiver, transmitter, ...super.props];
}

class ChannelConnect extends ChannelEvent {}

class ChannelBan extends ChannelEvent {}

class ChannelSuspend extends ChannelEvent {}

class ChannelTimeout extends ChannelEvent {
  final Duration duration;

  ChannelTimeout(this.duration);

  @override
  List<Object?> get props => [duration, ...super.props];
}
