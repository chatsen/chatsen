import 'package:flutter_bloc/flutter_bloc.dart';
import '/StreamOverlay/StreamOverlayState.dart';

import 'StreamOverlayEvent.dart';

class StreamOverlayBloc extends Bloc<StreamOverlayEvent, StreamOverlayState> {
  StreamOverlayBloc() : super(StreamOverlayClosed()) {
    on<StreamOverlayOpen>((event, emit) {
      emit(StreamOverlayOpened(
        channelName: event.channelName,
      ));
    });
    on<StreamOVerlayClose>((event, emit) {
      emit(StreamOverlayClosed());
    });
  }
}
