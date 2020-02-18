import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  Authenticated,
  Unauthenticated,
  CallPage,
  EndCallPage
}

class WebSocketClass with ChangeNotifier {

  WebSocketChannel _channel;

  //String _url = "ws://192.168.1.37:8080";
  String _url = "wss://echo.websocket.org";

  Status status = Status.Unauthenticated;

  Timer timerPeriod = Timer(Duration(seconds: 2), () {});
  Timer timerTimeout = new Timer(Duration(seconds: 0), () {});

  List<String> messageStringHWcontroller = new List<String>();
  List<String> messageStringMain = new List<String>();

  WebSocketClass();

  Future<bool> wsconnect() async {
    try{
      _channel = IOWebSocketChannel.connect(_url);
      if (_channel == null) {  

        timerPeriod.cancel();
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
          // onMessage:

          try{
            //
            // Gestione Timer timeout
            //
            timerTimeout.cancel();     
            timerTimeout = Timer(Duration(seconds: 4), () {
              disconnect();
            });
          }catch(e){print(e);}

          if(message =='ping')           
            return;

          //
          // Controlli eseguiti tramite la logica dei comandi del WebServer di Prova
          //

          if((message as String).split('@')[1].startsWith('Main'))
            messageStringMain.add(message);
          
          else if((message as String).split('@')[1].startsWith('HWController'))
            messageStringHWcontroller.add(message);

          notifyListeners();
        }, onDone: () {
          print('ws closed');
          timerPeriod.cancel();
          status = Status.Unauthenticated;
          notifyListeners();
        }, onError: (error) {
          print('error $error');
          timerPeriod.cancel();
          status = Status.Unauthenticated;
          notifyListeners();
        });
      }      

      //
      // Timer utilizzato per il poll del WebServer
      //
      timerPeriod = Timer.periodic(Duration(seconds: 2), (timer) {
        send('ping');
      });

      status = Status.Authenticated;
      notifyListeners();
      return true;
      }catch(e){
        print('erro $e');
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
      if(!timerTimeout.isActive)
      {
         timerTimeout = Timer(Duration(seconds: 4), () {
              disconnect();
        });
      }
      _channel.sink.add(data);
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
