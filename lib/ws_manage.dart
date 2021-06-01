import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  Authenticated,
  Unauthenticated,
}

class InputClass {
  int id;
  TextButton button;

  InputClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class StepperMotorClass {
  int id;
  TextButton button;

  StepperMotorClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class DcMotorClass {
  int id;
  TextButton button;

  DcMotorClass(id, button) {
    this.id = id;
    this.button = button;
  }
}

class SolenoidClass {
  int id;
  TextButton button;

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

class ThemeChangerClass with ChangeNotifier {
  SharedPreferences _prefs;

  ThemeChangerClass(SharedPreferences _p) {
    _prefs = _p;
  }

  get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  set isDarkMode(bool _dark) {
    _prefs.setBool('isDarkMode', _dark);
    notifyListeners();
  }
}

class WebSocketClass with ChangeNotifier {
  SharedPreferences _prefs;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  WebSocketClass(SharedPreferences _p) {
    _prefs = _p;
  }

  String get ws_url =>
      _prefs.getString('ws_url') ??
      'ws://127.0.0.1:5001'; // loopback as default
  set ws_url(String _url) {
    _prefs.setString('ws_url', _url);
    notifyListeners();
  }

  WebSocketChannel _channel;

  Status status = Status.Unauthenticated;

  Timer timerPeriod = Timer(Duration(seconds: 1), () {});
  Timer timerInputAnalog = Timer(Duration(seconds: 1), () {});

  int missedPing = 0;

  List<String> messageStringHWcontroller = <String>[];
  List<String> messageStringMain = <String>[];

  List<int> outputList = <int>[];
  List<int> inputList = <int>[];

  Uint8List image;
  int photocellsIndex = -1;
  int counter = 0;
  int indexReadAnalog = 0;
  int index = -1;
  BigInt result = BigInt.from(0);
  int analogInput = 0;

  List<List<TextButton>> photocellButtons = <List<TextButton>>[];
  List<InputClass> inputButtons = <InputClass>[];
  List<DcMotorClass> dcMotorButtons = <DcMotorClass>[];
  List<StepperMotorClass> stepperMotorButtons = <StepperMotorClass>[];
  List<SolenoidClass> solenoidButtons = <SolenoidClass>[];
  List<OutputClass> outputButtons = <OutputClass>[];

  Future<bool> wsconnect() async {
    try {
      missedPing = 0;
      _channel = WebSocketChannel.connect(
        Uri.parse(ws_url),
      );

      if (_channel == null) {
        timerPeriod.cancel();
        status = Status.Unauthenticated;
        return false;
      } else {
        _channel.stream.listen((message) {
          //print('rx:$message');
          String message2 = message;

          try {
          List<String> split = message2.split(RegExp("[!_@]+"));
          if (split[1] == 'ReadAnalogInput') {
            missedPing--; // retrig the polling: keep alive the connection
            split = message2.split(RegExp("[\s_@)(!]+"));
            if (indexReadAnalog == 5) {
              indexReadAnalog = 0;
            }
            if (indexReadAnalog == 0) {
              inputList[0] = int.parse(split[3]);
            }
            if (indexReadAnalog == 1) {
              inputList[1] = int.parse(split[3]);
            }
            if (indexReadAnalog == 2) {
              inputList[2] = int.parse(split[3]);
            }
            if (indexReadAnalog == 3) {
              inputList[3] = int.parse(split[3]);
            }
            if (indexReadAnalog == 4) {
              inputList[4] = int.parse(split[3]);
            }
            indexReadAnalog++;
          } else if (split[1] == 'ReadDigitalInput') {
            split = message2.split(RegExp("[_@)(!]+"));
            result = BigInt.parse(split[3].split('x')[1], radix: 16);
          } else if (split[1] == "InvertImage") {
            split = split[2].split('[')[1].split(']');
            print(split);
            image = base64.decode(split[0]);
          } else {
            print("listened: " + message);
          }
          notifyListeners();

          } catch (e) {
            print(e);
            disconnect('unknown reply from client');
        }

        }, onDone: () {
          disconnect('');
        }, onError: (e) {
          print(e);
          disconnect('Connection not accepted by client');
        });
      } 

      // Timer utilizzato per il poll del WebServer
      for (int i = 0; i < 5; i++) {
        inputList.add(0);
      }
      for (int i = 0; i < 10; i++) {
        outputList.add(0);
      }

      timerPeriod = Timer.periodic(Duration(seconds: 2), (timer2) {
        send('CMD_ReadDigitalInput@Main#');
      });

      timerInputAnalog = Timer.periodic(Duration(seconds: 1), (timer) {
        if (missedPing++ > 3) {
          disconnect('Missing reply from client');
        } else {
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
        }
      });

      status = Status.Authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      print('error $e');
      status = Status.Unauthenticated;
      disconnect(e.toString());
      return false;
    }
  }

  Future<void> disconnect(String message) async {

    timerPeriod.cancel();
    timerInputAnalog.cancel();

    if (Status == Status.Unauthenticated)
      return false;
    status = Status.Unauthenticated;
    notifyListeners();

    if (!message.isEmpty) {
      scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ));
    }

    try {
      _channel.sink.close(); // trigger listen onDone
    } catch (e) {
      print('sink.close error: $e');
    }
  }

  void send(String data) {
    //print('tx:$data');
    try {
      _channel.sink.add(data);
    } catch (err) {
      print(err);
    }
  }

  void generateButtonsList(BuildContext context) {
    try {
      photocellButtons = <List<TextButton>>[];
      inputButtons = <InputClass>[];
      stepperMotorButtons = <StepperMotorClass>[];
      dcMotorButtons = <DcMotorClass>[];
      solenoidButtons = <SolenoidClass>[];
      outputButtons = <OutputClass>[];
      photocellsIndex = 0;

      for (int i = 0; i < 5; i++) {
        photocellButtons.add(<TextButton>[]);
      }

      for (int i = 0, i2 = 1; i < 50; i++, i2++) {
        photocellButtons[photocellsIndex].add(new TextButton(
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
        if (i2 % 10 == 0) {
          photocellsIndex++;
        }
      }
      for (int i = 0; i < 5; i++) {
        inputButtons.add(new InputClass(
            i + 1,
            new TextButton(
              onPressed: () {
                index = i + 1;
                Navigator.pushNamed(context, '/inputAnalogicPage');
              },
              child: inputList.isNotEmpty
                  ? Text('Analog Input ${i + 1}:  ${inputList[i]}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                  : Text('Analog Input ${i + 1}'),
            )));
      }
      for (int i = 0; i < 20; i++) {
        stepperMotorButtons.add(new StepperMotorClass(
            i + 1,
            new TextButton(
                onPressed: () {
                  index = i + 1;
                  Navigator.pushNamed(context, '/StepperMotorPage');
                },
                child: Text('Stepper motor ${i + 1}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)))));
      }
      for (int i = 0; i < 10; i++) {
        dcMotorButtons.add(new DcMotorClass(
            i + 1,
            new TextButton(
                onPressed: () {
                  index = i + 1;
                  Navigator.pushNamed(context, '/DCMotorPage');
                },
                child: Text('DC Motor ${i + 1}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)))));
        solenoidButtons.add(new SolenoidClass(
            i + 1,
            new TextButton(
                onPressed: () {
                  index = i + 1;
                  Navigator.pushNamed(context, '/SolenoidPage');
                },
                child: Text('Solenoid ${i + 1}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)))));
        outputButtons.add(new OutputClass(
            i + 1,
            new Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Digital Out ${i + 1}',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              outputList[i] == 0
                  ? Icon(Icons.block, color: Colors.red)
                  : Icon(Icons.check, color: Colors.green)
            ])));
      }
      photocellsIndex = 0;
    } catch (e) {
      print(e);
    }
  }
}
