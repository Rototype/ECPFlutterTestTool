import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'main.dart';

enum Status { Authenticated, Authenticating, Unauthenticated}

class Ws with ChangeNotifier {
  List<String> _list = new List<String>();
  WebSocketChannel _channel;

  List<String> get list => _list;
  
  String _url = "wss://echo.websocket.org";
  Status _status = Status.Unauthenticated;
  Ws.instance();

  Status get status => _status;
  Future<bool> wsconnect() async {
    try {
      _channel = HtmlWebSocketChannel.connect(_url);
     _list.add('Messages');

      if (_channel == null) {
        _status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
            print('data: $message');    
            _list.add('data: $message');            
            notifyListeners();
          }, onDone: () {
            print('done');
            _status = Status.Unauthenticated;
            notifyListeners();
          }, onError: (error) {
            print(error);
            _status = Status.Unauthenticated;
            notifyListeners();
          },
        );       
      }
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    } catch (err) { 
      print('connect error');
      _status = Status.Unauthenticated;
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
      _channel.sink.add(data);
    } catch (err) { 
      print('sink.add error');
    }
  }
}