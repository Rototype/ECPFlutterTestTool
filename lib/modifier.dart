import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';


class Modifier with ChangeNotifier{

  HtmlWebSocketChannel channel;

  List<String> x3 = new List<String>();
  List<String> x2 = new List<String>();

  void connect(){

   channel = HtmlWebSocketChannel.connect("wss://echo.websocket.org");

    try{
    channel.stream.listen((message) { 
        if(message =='cambia 3')
          x3.add(message);
        else
          x2.add(message);
        notifyListeners();
      }
    );
    }catch(e){
      print(e);
    }
  }

  void send(String prova){
    channel.sink.add(prova);
  }
}