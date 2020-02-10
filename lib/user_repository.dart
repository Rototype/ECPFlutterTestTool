import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status { Authenticated, Authenticating, Unauthenticated, CallPage, EndCallPage }

class UserRepository with ChangeNotifier {
  WebSocketChannel _channel;
  String _url = "wss://echo.websocket.org";
  Status status = Status.Unauthenticated;
  Timer timer;
  List<String> messageStringHWcontroller = new List<String>() ;
  List<String> messageStringMain = new List<String>() ;
  List<String> messageList = new List<String>();

  UserRepository();

  Future<bool> wsconnect() async {
    try {
      _channel = HtmlWebSocketChannel.connect(_url);
      if (_channel == null) {
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
          String x = message;
          messageList = x.split('@');
          if(messageList[1].startsWith('Main'))
          {                      
            messageStringMain.add(message);
          }
          else
          {
            messageStringHWcontroller.add(message);    
          }       
          notifyListeners();

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
      messageStringHWcontroller = new List<String>();
      messageStringMain = new List<String>();
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
  void openEndCall() {
    status = Status.EndCallPage;
    notifyListeners();
  }
    void openHome() {
    status = Status.Authenticated;
    notifyListeners();
  }
    void clearHW() {
    messageStringHWcontroller = new List<String>();
    notifyListeners();
  }
    void clearMain() {
    messageStringMain = new List<String>();
    notifyListeners();
  }

}
