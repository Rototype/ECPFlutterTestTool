import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket.dart';

class WebKeyFinder implements SocketFinder {
  dynamic imageWeb;
  HtmlWebSocketChannel channel;

  WebKeyFinder() {
    print("Web OK");
    // storing something initially just to make sure it works. :)
  }

  WebSocketChannel getSocketValue(String url) {
    return channel = HtmlWebSocketChannel.connect(url);
  }

  bool isWeb() {
    return true;
  }
 

  void setSocketValue(String key, String value) {}
}

SocketFinder getSocketFinder() => WebKeyFinder();
