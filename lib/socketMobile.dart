import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket.dart';

class SharedPrefKeyFinder implements SocketFinder {
  IOWebSocketChannel channel;
  File imageMobile;
  final picker = ImagePicker();

  SharedPrefKeyFinder() {
    print('Mobile OK');
  }

  bool isWeb() {
    return false;
  }


  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageMobile = File(pickedFile.path);
    }
  }

  getImage() async {
    return await imageMobile.readAsBytes();
  }

  WebSocketChannel getSocketValue(String url) {
    return channel = IOWebSocketChannel.connect(url);
  }
}

SocketFinder getSocketFinder() => SharedPrefKeyFinder();
