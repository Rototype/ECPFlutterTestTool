import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/html.dart';
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

   Timer timerPeriod = Timer(Duration(seconds: 2), () {         
            
        });
  Timer timer = new Timer(Duration(seconds: 0), () {});

  List<String> messageStringHWcontroller = new List<String>();
  List<String> messageStringMain = new List<String>();
  List<String> messageList = new List<String>();

  String finished ="";
  double percent =0;
  String percent2;

  WebSocketClass();

  Future<bool> wsconnect() async {
      
      _channel = HtmlWebSocketChannel.connect(_url);
      if (_channel == null) {  

        timerPeriod.cancel();
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
          try{
            timer.cancel();     
            timer = Timer(Duration(seconds: 4), () {
              disconnect();
            });
          }catch(e){print(e);}
            String x = message;

            if(x=='ping')           
              return;

            messageList = x.split('@');
            if (message == 'EVT_Garbage@Main#') 
              return;
            if (messageList[1].startsWith('Main')) {
              messageStringMain.add(message);
            } 
            else 
            {
              if(messageList[0].split('_')[1].startsWith('UpdateFirmware'))
              {
                if(messageList[1].endsWith('("FAILED")'))
                {
                  percent = 0;
                  finished = 'Update Error';
                  notifyListeners();         
                  return;
                }
                else if(!messageList[1].endsWith('#') || !messageList[1].endsWith('("GONE")'))
                  percent = (double.parse(((messageList[1].split('('))[1].split(',')[0]).trim()))/100;                
                
                if(percent==1)
                {
                  finished='Update completed successfully';
                }
              }             
            }
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
      timerPeriod = Timer.periodic(Duration(seconds: 2), (timer) {
        send('ping');
      });
      status = Status.Authenticated;
        notifyListeners();
      return true;
      
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
      if(!timer.isActive)
      {
         timer = Timer(Duration(seconds: 4), () {
              disconnect();
        });
      }
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

  void starTimer(String data){
    // timerPeriod = Timer(Duration(seconds: 2), () {         
    //   send('ping');
    //   print('ping');
    // });
    try {
      if(!timer.isActive)
      {
         timer = Timer(Duration(seconds: 4), () {
              disconnect();
        });
      }
      _channel.sink.add(data); // trigger listen onMessage
    } catch (err) {
      print(err);
    }
  }
}
