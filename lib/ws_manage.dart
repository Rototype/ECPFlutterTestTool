import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  Authenticated,
  Authenticating,
  Unauthenticated,
  CallPage,
  EndCallPage
}

class WebSocketClass with ChangeNotifier {
  WebSocketChannel _channel;
  String _url = "ws://192.168.1.127:8080";
  Status status = Status.Unauthenticated;
  Timer timerPeriod;
  Timer timer = new Timer(Duration(seconds: 1), () {});
  List<String> messageStringHWcontroller = new List<String>();
  List<String> messageStringMain = new List<String>();
  List<String> messageList = new List<String>();
  bool isReceived;

  WebSocketClass();

  Future<bool> wsconnect() async {
    try {
      _channel = HtmlWebSocketChannel.connect(_url);
      timerPeriod = Timer.periodic(Duration(seconds: 2), (timerPeriod) {
        send('ping');
      });

      if (_channel == null) {
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
          timer.cancel();
          timer = Timer(Duration(seconds: 4), () {
            disconnect();
          });
          String x = message;
          messageList = x.split('@');
          if (message == 'EVT_Garbage@Main#') return;
          if (messageList[1].startsWith('Main')) {
            messageStringMain.add(message);
          } else {
            messageStringHWcontroller.add(message);
          }
          notifyListeners();
        }, onDone: () {
          print('done');
          status = Status.Unauthenticated;
          timerPeriod.cancel();
          notifyListeners();
        }, onError: (error) {
          print('error $error');
          timerPeriod.cancel();
          status = Status.Unauthenticated;
          notifyListeners();
        });
      }
      status = Status.Authenticated;
      notifyListeners();
      return true;
    } catch (err) {
      print('connect error');
      timerPeriod.cancel();
      status = Status.Unauthenticated;
      return true;
    }
  }

  Future<void> disconnect() async {
    try {
      timerPeriod.cancel();
      _channel.sink.close(); // trigger listen onDone
      messageStringHWcontroller = new List<String>();
      messageStringMain = new List<String>();
    } catch (err) {
      print('sink.close error');
    }
  }

  void send(String data) {
    try {
      _channel.sink.add(data); // trigger listen onMessage
    } catch (err) {
      print(err);
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
