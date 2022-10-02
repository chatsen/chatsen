import 'package:flutter_bloc/flutter_bloc.dart';

import 'browser_tab.dart';

class BrowserState extends Cubit<List<BrowserTab>> {
  BrowserState() : super([]);
}
