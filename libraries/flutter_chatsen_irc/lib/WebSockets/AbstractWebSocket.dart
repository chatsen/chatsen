import '../WebSockets/NoWebSocket.dart' if (dart.library.io) 'IOWebSocket.dart' if (dart.library.html) 'HtmlWebSocket.dart';

dynamic connectWebSocket(url) => getAbstractWebSocket(url);
