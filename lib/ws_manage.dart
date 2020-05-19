import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/IO.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  Authenticated,
  Unauthenticated,
}

class InputClass {
  int id;
  FlatButton button;
  InputClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class StepperMotorClass {
  int id;
  FlatButton button;
  StepperMotorClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class DcMotorClass {
  int id;
  FlatButton button;
  DcMotorClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class SolenoidClass {
  int id;
  FlatButton button;
  SolenoidClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class OutputClass {
  int id;
  Row row;
  OutputClass(id, row) {
    this.id = id;
    this.row = row;
  }
}

class WebSocketClass with ChangeNotifier {
  WebSocketChannel _channel;

  //String _url = "ws://127.0.0.1:5001";
  //String _url = "ws://192.168.1.101:5001";
  //String _url = "ws://192.168.1.37:8080";

  Status status = Status.Unauthenticated;

  Timer timerPeriod = Timer(Duration(seconds: 1), () {});
  Timer timerInputAnalog = Timer(Duration(seconds: 1), () {});

  Timer timerTimeout = new Timer(Duration(seconds: 0), () {});

  List<String> messageStringHWcontroller = new List<String>();
  List<String> messageStringMain = new List<String>();

  List<int> outputList = new List<int>();
  List<int> inputList = new List<int>();

  Uint8List image;
  int photocellsIndex = -1;
  int counter = 0;
  int indice = 0;
  int index = -1;
  BigInt result = BigInt.from(0);
  int analogInput =0;

  String url;
  
  TextEditingController ipurl = new TextEditingController();


  List<List<FlatButton>> photocellButtons = new List<List<FlatButton>>();
  List<InputClass> inputButtons = new List<InputClass>();
  List<DcMotorClass> dcMotorButtons = new List<DcMotorClass>();
  List<StepperMotorClass> stepperMotorButtons = new List<StepperMotorClass>();
  List<SolenoidClass> solenoidButtons = new List<SolenoidClass>();
  List<OutputClass> outputButtons = new List<OutputClass>();

  WebSocketClass();

  Future<bool> wsconnect() async {
    try {
      _channel = IOWebSocketChannel.connect(ipurl.text);
            if (_channel == null) {
              timerPeriod.cancel();
              status = Status.Unauthenticated;
              return false;
            } else {
              _channel.stream.listen((message) {
                // onMessage:
      
                try {
                  //
                  // Gestione Timer timeout
                  //
                  timerTimeout.cancel();
      
                  timerTimeout = Timer(Duration(seconds: 60), () {
                    disconnect();
                  });
                } catch (e) {
                  print(e);
                }
      
                
      
                String message2 = message;
                
                //
                // Controlli eseguiti tramite la logica dei comandi del WebServer di Prova
                //
                List<String> split = message2.split(RegExp("[!_@]+"));
                
                if(split[1] == 'ReadAnalogInput'){
                  split = message2.split(RegExp("[\s_@)(!]+"));
                  if(indice==5)
                  {
                    indice=0;
                  }
                  if(indice==0){
                    inputList[0]=int.parse(split[3]);
                  }
                  if(indice==1){
                    inputList[1]=int.parse(split[3]);
                  }
                  if(indice==2){
                    inputList[2]=int.parse(split[3]);
                  }
                  if(indice==3){
                    inputList[3]=int.parse(split[3]);
                  }
                  if(indice==4){
                    inputList[4]=int.parse(split[3]);
                  }
                  indice++;
                }
                else if (split[1] == 'ReadDigitalInput') {
                  split = message2.split(RegExp("[_@)(!]+"));
                  result = BigInt.parse(split[3].split('x')[1], radix: 16);
                }
                else if (split[1] == "InvertImage"){
                  split = split[2].split('[')[1].split(']');
                  print(split);
                  image =  base64.decode(split[0]);    
                }
                else {
                  print("listened: "+message);
                }
      
                notifyListeners();
              }, onDone: () {
                print('ws closed');
      
                timerPeriod.cancel();
                timerTimeout.cancel();
                timerInputAnalog.cancel();
                status = Status.Unauthenticated;
                notifyListeners();
              }, onError: (error) {
                print('error $error');
      
                timerPeriod.cancel();
                timerTimeout.cancel();
                timerInputAnalog.cancel();
                status = Status.Unauthenticated;
                notifyListeners();
              });
            }
      
            
            // Timer utilizzato per il poll del WebServer
          for(int i=0;i<5;i++)
          {
            inputList.add(0);
          }
          for(int i=0;i<10;i++)
          {
            outputList.add(0);
          }
      
          timerPeriod = Timer.periodic(Duration(seconds: 2), (timer2) {
            send('CMD_ReadDigitalInput@Main#');
          });
      
          timerInputAnalog = Timer.periodic(Duration(milliseconds: 800), (timer) {
            send('CMD_ReadAnalogInput@Main($indice)');
          });
      
      
         
          status = Status.Authenticated;
          notifyListeners();
          return true;
           } catch (e) {
            print('error $e');
            status = Status.Unauthenticated;
            return false;
          }
        }
      
        Future<void> disconnect() async {
          try {
            timerPeriod.cancel();
            _channel.sink.close(); // trigger listen onDone
          } catch (err) {
            print('sink.close error');
          }
        }
      
        void send(String data) {
          try {
            if (!timerTimeout.isActive) {
              timerTimeout = Timer(Duration(seconds: 60), () {
                disconnect();
              });
            }
            List<String> split = data.split(RegExp("[\s_@)(!]+"));
      
            if(split[1] != 'ReadAnalogInput' && split[1] != 'ReadDigitalInput' && split[1] !=  'InvertImage'){
              print(data);
            }
            _channel.sink.add(data);
          } catch (err) {
            print(err);
          }
        }
      
        void generateButtonsList(BuildContext context) {

          try{
          photocellButtons = new List<List<FlatButton>>();
          inputButtons = new List<InputClass>();
          stepperMotorButtons = new List<StepperMotorClass>();
          dcMotorButtons = new List<DcMotorClass>();
          solenoidButtons = new List<SolenoidClass>();
          outputButtons = new List<OutputClass>();
          photocellsIndex = 0;
          
          for(int i=0; i<5;i++)
          {
            photocellButtons.add(new List<FlatButton>());
          }
      
          for (int i = 0, i2 = 1; i < 50; i++, i2++) {
      
            
            photocellButtons[photocellsIndex].add(new FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      result & BigInt.from(pow(2, i)) == BigInt.from(0)
                          ? Hero(
                              tag: 'hero $i',
                              child: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.greenAccent,
                              ))
                          : Hero(
                              tag: 'hero $i',
                              child: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.red,
                              )),
                      Text('F ${i + 1}'),
                    ],
                  ),
                  onPressed: () {
                    index = i + 1;
                    Navigator.pushNamed(context, '/PhotocellPage');
                  },
                ));
            if(i2%10 == 0)
            {
              photocellsIndex ++;
            }
          }
          for (int i = 0; i < 5; i++) {
            inputButtons.add(new InputClass(
                i + 1,
                new FlatButton(
                    onPressed: () {
                      index = i + 1;
                      Navigator.pushNamed(context, '/inputAnalogicPage');
                    },
                    child:
                    inputList.isNotEmpty ?
                     Text('Analog Input ${i + 1}:  ${inputList[i]}',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                      ) : Text('Analog Input ${i + 1}'),
                      
                    )
                  )
                );
          }
          for (int i = 0; i < 20; i++) {
            stepperMotorButtons.add(new StepperMotorClass(
                i + 1,
                new FlatButton(
                    onPressed: () {
                      index = i + 1;
                      Navigator.pushNamed(context, '/StepperMotorPage');
                    },
                    child: Text('Stepper motor ${i + 1}',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))));
          }
          for (int i = 0; i < 10; i++) {
            dcMotorButtons.add(new DcMotorClass(
                i + 1,
                new FlatButton(
                    onPressed: () {
                      index = i + 1;
                      Navigator.pushNamed(context, '/DCMotorPage');
                    },
                    child: Text('DC Motor ${i + 1}',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))));
            solenoidButtons.add(new SolenoidClass(
                i + 1,
                new FlatButton(
                    onPressed: () {
                      index = i + 1;
                      Navigator.pushNamed(context, '/SolenoidPage');
                    },
                    child: Text('Solenoid ${i + 1}',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))));
            outputButtons.add(new OutputClass(
                i + 1,
                new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Digital Output ${i + 1}',
                          style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      outputList[i] == 0 ?
                      Icon(
                        Icons.block,
                        color: Colors.red
                      )
                      : Icon(
                        Icons.check,
                        color: Colors.green
                      )
                      
                    ] 
                )
            ));
          }
          photocellsIndex = 0;
          }catch(e){
            print(e);
          }
        }
}
