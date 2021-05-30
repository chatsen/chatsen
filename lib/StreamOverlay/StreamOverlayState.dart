import 'package:equatable/equatable.dart';

class StreamOverlayState extends Equatable {
  @override
  List<Object> get props => [];
}

class StreamOverlayClosed extends StreamOverlayState {}

class StreamOverlayOpened extends StreamOverlayState {
  final String channelName;

  StreamOverlayOpened({
    this.channelName,
  });

  @override
  List<Object> get props => [channelName, ...super.props];
}
