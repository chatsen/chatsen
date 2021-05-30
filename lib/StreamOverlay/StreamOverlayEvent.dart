import 'package:equatable/equatable.dart';

class StreamOverlayEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StreamOVerlayClose extends StreamOverlayEvent {}

class StreamOverlayOpen extends StreamOverlayEvent {
  final String channelName;

  StreamOverlayOpen({
    this.channelName,
  });

  @override
  List<Object> get props => [channelName, ...super.props];
}
