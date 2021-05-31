
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket.dart';

class SharedPrefKeyFinder implements SocketFinder {
  IOWebSocketChannel channel;
  
  SharedPrefKeyFinder() {
    print('Mobile OK');
  }

  bool isWeb() {
    return false;
  }

  WebSocketChannel getSocketValue(String url) {
    return channel = IOWebSocketChannel.connect(url);
  }
}

SocketFinder getSocketFinder() => SharedPrefKeyFinder();
