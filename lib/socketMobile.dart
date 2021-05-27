import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket.dart';

class SharedPrefKeyFinder implements SocketFinder {
  IOWebSocketChannel channel;
  File imageMobile;
  
  SharedPrefKeyFinder() {
    print('Mobile OK');
  }

  bool isWeb() {
    return false;
  }

  Future<void> pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageMobile = image;
  }

  
  getImage() async {
    return await imageMobile.readAsBytes();
  }

  WebSocketChannel getSocketValue(String url) {
    return channel = IOWebSocketChannel.connect(url);
  }
}

SocketFinder getSocketFinder() => SharedPrefKeyFinder();
