import 'dart:async';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status { Authenticated, Authenticating, Unauthenticated, CallPage }

class UserRepository with ChangeNotifier {
  WebSocketChannel _channel;
  String _url = "wss://echo.websocket.org";
  Status status = Status.Unauthenticated;
  Timer timer;
  List<String> messageString = new List<String>() ;

  UserRepository();

  Future<bool> wsconnect() async {
    try {
      _channel = HtmlWebSocketChannel.connect(_url);
      if (_channel == null) {
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
        
          messageString.add(message);
          notifyListeners();

          // if (message == 'ping') print(message);  
          // var split = message.split('@');
          // switch (split[1]) {
          //   case 'call':
          //     if(status == Status.CallPage)
          //     {
          //       print('call: $message');
          //       messageString.add(message);
          //       notifyListeners();
          //     }
          //     else{
          //       print('call: $message');
          //       messageString.add(message);
          //     }
          //     break;
          //   case 'endCall':
          //     print('endCall: $message');
          //     break;
          //   case 'brightness':
          //     print('brightness: $message');
          //     break;
          //   case 'camera':
          //     print('camera: $message');
          //     break;
          // }
        }, onDone: () {
          print('done');
          status = Status.Unauthenticated;
          notifyListeners();
        }, onError: (error) {
          print('error $error');
          status = Status.Unauthenticated;
          notifyListeners();
        });
      }
      status = Status.Authenticated;
      notifyListeners();
      return true;
    } catch (err) {
      print('connect error');
      status = Status.Unauthenticated;
      return true;
    }
  }

  Future<void> disconnect() async {
    try {
      _channel.sink.close(); // trigger listen onDone
    } catch (err) {
      print('sink.close error');
    }
  }

  Future<void> send(String data) async {
    try {
      _channel.sink.add(data); // trigger listen onMessage
    } catch (err) {
      print('sink.add error');
    }
  }

  void openCall() {
    status = Status.CallPage;
    notifyListeners();
  }
    void openHome() {
    status = Status.Authenticated;
    notifyListeners();
  }
}
