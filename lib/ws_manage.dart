import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  Authenticated,
  Unauthenticated,
}

class PhotocellsClass{
  int id;
  FlatButton button;
  PhotocellsClass(int id, FlatButton button){
    this.id=id;
    this.button=button;
  }

}
class InputClass{
  int id;
  FlatButton button;
  InputClass(id, button){
    this.id=id;
    this.button=button;
  }
}
class StepperMotorClass{
  int id;
  FlatButton button;
  StepperMotorClass(id, button){
    this.id=id;
    this.button=button;
  }
}
class DcMotorClass{
  int id;
  FlatButton button;
  DcMotorClass(id, button){
    this.id=id;
    this.button=button;
  }
}
class SolenoidClass{
  int id;
  FlatButton button;
  SolenoidClass(id, button){
    this.id=id;
    this.button=button;
  }
}


class WebSocketClass with ChangeNotifier {

  WebSocketChannel _channel;

  //String _url = "ws://192.168.1.101:5001";
  //String _url = "ws://192.168.1.37:8080";
  String _url = "wss://echo.websocket.org";

  Status status = Status.Unauthenticated;

  Timer timerPeriod = Timer(Duration(seconds: 2), () {});
  Timer timerTimeout = new Timer(Duration(seconds: 0), () {});

  List<String> messageStringHWcontroller = new List<String>();
  List<String> messageStringMain = new List<String>();

  int index=0;
  List<PhotocellsClass> photocellButtons = new List<PhotocellsClass>();
  List<InputClass> inputButtons = new List<InputClass>();
  List<DcMotorClass> dcMotorButtons = new List<DcMotorClass>();
  List<StepperMotorClass> stepperMotorButtons = new List<StepperMotorClass>();
  List<SolenoidClass> solenoidButtons = new List<SolenoidClass>();

  WebSocketClass();

  Future<bool> wsconnect() async {
    try{
      _channel = HtmlWebSocketChannel.connect(_url);
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
    }catch(e){
      print('erro $e');
    }
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

  void generateButtonsList(BuildContext context){
    photocellButtons = new List<PhotocellsClass>();
    for(int i=0; i<50 ;i++){
      photocellButtons.add(
        new PhotocellsClass(
          i+1, 
          new FlatButton(
            onPressed: (){
              index=i+1;            
               Navigator.pushNamed(context,'/PhotocellPage' );
            }, 
            child: Text('Photocell ${i+1}')
          )    
        )
      );
    }
    for(int i=0;i<5;i++){
      inputButtons.add(
        new InputClass(
          i+1,
          new FlatButton(
            onPressed:() { print('esisto pur io');}, 
            child: Text('Analogic Input ${i+1}')
          )
        )
      );
    }
    for(int i=0;i<20;i++){
      stepperMotorButtons.add(
        new StepperMotorClass(
          i+1,
          new FlatButton(
            onPressed: (){print('Io non esisto, o forse si?');}, 
            child: Text('Stepper motor ${i+1}')
          )
        )
      );
    }
    for(int i=0; i<10;i++){
      dcMotorButtons.add(
        new DcMotorClass(
          i+1,
          new FlatButton(
            onPressed: (){print('esistiamo tutti');}, 
            child: Text('DC Motor ${i+1}')
          )
        )
      );
      solenoidButtons.add(
        new SolenoidClass(
          i+1, 
          new FlatButton(
            onPressed: (){print('siamo solenoidi');}, 
            child: Text('Solenoids ${i+1}')
          )
        )      
      );
    }
  }
}
