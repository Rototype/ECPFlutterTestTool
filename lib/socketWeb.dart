import 'package:image_picker_web/image_picker_web.dart';
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

  Future<void> pickImage() async {
    var image = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    imageWeb = image;
  }

  getImage() {
    return imageWeb;
  }

  void setSocketValue(String key, String value) {}
}

SocketFinder getSocketFinder() => WebKeyFinder();
