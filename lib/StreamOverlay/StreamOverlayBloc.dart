import 'package:flutter_bloc/flutter_bloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';

import 'StreamOverlayEvent.dart';

class StreamOverlayBloc extends Bloc<StreamOverlayEvent, StreamOverlayState> {
  StreamOverlayBloc() : super(StreamOverlayClosed());

  @override
  Stream<StreamOverlayState> mapEventToState(StreamOverlayEvent event) async* {
    if (event is StreamOverlayOpen) {
      yield StreamOverlayOpened(
        channelName: event.channelName,
      );
    } else if (event is StreamOVerlayClose) {
      yield StreamOverlayClosed();
    }
  }
}
