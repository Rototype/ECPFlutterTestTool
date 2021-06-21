import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Status {
  SocketConnected,
  SocketNotConnected,
  SocketCrash
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

  Status _status = Status.SocketNotConnected;
  Status get status => _status;
  set status(Status st) {
    _status = st;
    notifyListeners();
  }

  // invoked to change state from SocketCrash to SocketNotConnected without notifyListeners
  // SocketCrash returns to ConnectPage from any state, but we we only have to do it once.
  statusRemoveCrash() {
    _status = Status.SocketNotConnected;
  }

  Timer timerPeriod = Timer(Duration(seconds: 1), () {});
  Timer timerInputAnalog = Timer(Duration(seconds: 1), () {});

  final endRegExp = RegExp(r'END_(\w+)@Main(#|\((\w+)\)|\[(.+)\])');

  int missedPing = 0;

  var messageStringHWcontroller = <String>[];
  var messageStringMain = <String>[];

  var outputList = <int>[];
  var inputList = <int>[];
  var lastinputList = <int>[];

  Uint8List image;
  int photocellsIndex = -1;
  int counter = 0;
  int indexReadAnalog = 0;
  int index = -1;
  BigInt result = BigInt.from(0);
  int analogInput = 0;
  String lastDigitalInput = '';


  var photocellButtons = <List<TextButton>>[];
  var inputButtons = <InputClass>[];
  var dcMotorButtons = <DcMotorClass>[];
  var stepperMotorButtons = <StepperMotorClass>[];
  var solenoidButtons = <SolenoidClass>[];
  var outputButtons = <OutputClass>[];

  Future<bool> wsconnect() async {
    try {
      inputList.clear();
      lastinputList.clear();
      for (int i = 0; i < 5; i++) {
        inputList.add(0);
        lastinputList.add(-1);
      }
      outputList.clear();
      for (int i = 0; i < 10; i++) {
        outputList.add(0);
      }

      missedPing = 0;
      lastDigitalInput = '';
      status = Status.SocketConnected;

      _channel = WebSocketChannel.connect(
        Uri.parse(ws_url),
      );

      if (_channel == null) {
        disconnect('Socket failed');
        return false;
      } else {
        _channel.stream.listen((message) {
          print('rx:$message');

          // ---------------------------------------------------------------------------
          // to test the image send & receive + polling with an echo server:
          // docker run -d -p 8080:8080 inanimate/echo-server
          // ---------------------------------------------------------------------------
          /*
          if (message.toString().startsWith("Request served"))
            return;
          var s = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
          if ( message == 'CMD_ReadDigitalInput@Main#')
            message = 'END_ReadDigitalInput@Main(0x$s)';
          else if (message.toString().startsWith('CMD_'))
            message = 'END_' + message.toString().substring(4);
          */

          try {
            final match = endRegExp.firstMatch(message);

            switch(match[1]) {
              case 'ReadAnalogInput':

                missedPing--; // retrig the polling: keep alive the connection
                inputList[indexReadAnalog] = int.parse(match[3]);
                if (lastinputList[indexReadAnalog] != inputList[indexReadAnalog]) {
                  lastinputList[indexReadAnalog] = inputList[indexReadAnalog];
                  notifyListeners();
                }
                if (indexReadAnalog >= 4)
                  indexReadAnalog = 0;
                else
                  indexReadAnalog++;
              break;
              case 'ReadDigitalInput':
                if ( match[3] != lastDigitalInput) {
                    result = BigInt.parse(match[3].split('x')[1], radix: 16);
                    notifyListeners();
                    lastDigitalInput = match[3];
                }
                break;
              case 'InvertImage':
                image = base64.decode(match[4]);
                notifyListeners();
                break;
              default:
                print("listened: " + message);
                break;
            }


          } catch (e) {
            print(e);
            disconnect('unknown reply from client');
          }

        }, onDone: () {
          disconnect(''); // no text, so disconnect anyway, but we are happy
        }, onError: (e) {
          print('error $e');
          var msg = e.toString().split(':').last;
          disconnect(msg); 
        });
      } 

      

      timerPeriod = Timer.periodic(Duration(seconds: 2), (timer2) {
        send('CMD_ReadDigitalInput@Main#');
      });

      timerInputAnalog = Timer.periodic(Duration(seconds: 1), (timer) {
        if (missedPing++ > 5) {
          disconnect('Missing reply from client');
        } else {
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
          send('CMD_ReadAnalogInput@Main($indexReadAnalog)');
        }
      });

      return true;
    } catch (e) {
      print('error $e');
      var msg = e.toString().split(':').last;
      disconnect(msg);
      return false;
    }
  }

  Future<void> disconnect(String message) async {

    timerPeriod.cancel();
    timerInputAnalog.cancel();

    // alredy disconnected?
    if (status != Status.SocketConnected)
      return;

    if (message.isEmpty) {
      // user disconnects
      status = Status.SocketNotConnected;
    } else {
      // something bad happened
      status = Status.SocketCrash;
      scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(    
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error, color: Colors.red, size: 40),
            SizedBox(width: 10),
            Text(message)
          ]
        )
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
