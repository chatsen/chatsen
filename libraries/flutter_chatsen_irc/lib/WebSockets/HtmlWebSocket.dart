import 'package:web_socket_channel/html.dart';

dynamic getAbstractWebSocket(url) => HtmlWebSocketChannel.connect(url);
