import 'package:web_socket_channel/io.dart';

dynamic getAbstractWebSocket(url) => IOWebSocketChannel.connect(url);
