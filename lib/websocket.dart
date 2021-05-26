import 'package:web_socket_channel/web_socket_channel.dart';

import 'socket_finder_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'socketMobile.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'socketWeb.dart';

abstract class SocketFinder {
  // some generic methods to be exposed.

  /// returns a value based on the key
  WebSocketChannel getSocketValue(String url);

  bool isWeb();

  Future<void> pickImage() async {}

  /// stores a key value pair in the respective storage.
  getImage() {}

  /// factory constructor to return the correct implementation.
  factory SocketFinder() => getSocketFinder();
}
