import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'image.dart';

enum Status { socketConnected, socketNotConnected, socketCrash }

class WebSocketClass with ChangeNotifier {
  final SharedPreferences _prefs;
  final List<ImageBmp> bmpList;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  WebSocketClass(this._prefs, this.bmpList);

  String get wsUrl =>
      _prefs.getString('ws_url') ??
      'ws://localhost:5001'; // loopback as default
  set wsUrl(String _url) {
    _prefs.setString('ws_url', _url);
    notifyListeners();
  }

  WebSocketChannel _channel;

  Status _status = Status.socketNotConnected;
  Status get status => _status;
  set status(Status st) {
    _status = st;
    notifyListeners();
  }

  // invoked to change state from SocketCrash to SocketNotConnected without notifyListeners
  // SocketCrash returns to ConnectPage from any state, but we we only have to do it once.
  statusRemoveCrash() {
    _status = Status.socketNotConnected;
  }

  Timer _timerPeriod;

  void startSensorPolling() {
    _timerPeriod = Timer.periodic(const Duration(seconds: 1), (_) {
      if (missedPing++ > 5) {
        disconnect('Missing reply from client');
      } else {
        send('CMD_ReadDigitalInput@Main#');
      }
    });
  }

  void stopSensorPolling() {
    _timerPeriod.cancel();
  }

  void startInputPolling() {
    _timerPeriod = Timer.periodic(const Duration(seconds: 1), (_) {
      if (missedPing++ > 5) {
        disconnect('Missing reply from client');
      } else {
        send('CMD_ReadAnalogInput@Main(${indexReadAnalog + 1})');
      }
    });
  }

  void stopInputPolling() {
    _timerPeriod.cancel();
  }

  final endRegExp = RegExp(r'(EVT|END)_(\w+)@(\w+)(#|\((\w+)\)|\[(.+)\]|\{((.|\n)*?)})');

  int missedPing = 0;

  String configText = '';

  /////////////////////////////////////////////////////////////////
  static const int outputStateSize = 10;
  var _outputState = List.generate(outputStateSize, (_) => false);
  bool getOutputState(int idx) => _outputState[idx];
  void setOutputState(int idx, bool val) {
    if (_outputState[idx] != val) {
      _outputState[idx] = val;
      notifyListeners();
    }
  }

  void clearOutputValues() {
    _outputState = List.generate(outputStateSize, (_) => false);
  }

  /////////////////////////////////////////////////////////////////
  static const int solenoidStateSize = 10;
  var _solenoidState = List.generate(solenoidStateSize, (_) => false);
  bool getSolenoidState(int idx) => _solenoidState[idx];

  void setSolenoidState(int idx, bool val) {
    if (_solenoidState[idx] != val) {
      _solenoidState[idx] = val;
      notifyListeners();
    }
  }

  void clearSolenoidState() {
    _solenoidState = List.generate(solenoidStateSize, (_) => false);
  }

  /////////////////////////////////////////////////////////////////
  static const int dcMotorStateSize = 5;
  var _dcMotorState = List.generate(dcMotorStateSize, (_) => false);
  bool getdcMotorState(int idx) => _dcMotorState[idx];

  void setdcMotorState(int idx, bool val) {
    if (_dcMotorState[idx] != val) {
      _dcMotorState[idx] = val;
      notifyListeners();
    }
  }

  void cleardcMotorState() {
    _dcMotorState = List.generate(dcMotorStateSize, (_) => false);
  }

  /////////////////////////////////////////////////////////////////
  static const int stepperMotorStateSize = 20;
  var _stepperMotorState = List.generate(stepperMotorStateSize, (_) => false);
  bool getStepperMotorState(int idx) => _stepperMotorState[idx];

  void setStepperMotorState(int idx, bool val) {
    if (_stepperMotorState[idx] != val) {
      _stepperMotorState[idx] = val;
      notifyListeners();
    }
  }

  void clearStepperMotorState() {
    _stepperMotorState = List.generate(stepperMotorStateSize, (_) => false);
  }

  /////////////////////////////////////////////////////////////////
  static const int inputStateSize = 5;
  var inputState = List.generate(inputStateSize, (_) => 0);
  var lastinputState = List.generate(inputStateSize, (_) => 0);
  void clearinputState() {
    inputState = List.generate(inputStateSize, (_) => 0);
    lastinputState = List.generate(inputStateSize, (_) => 0);
  }

  static const int photocellStateSize = 50;
  void clearphotocellState() {
    result = BigInt.from(0);
    lastDigitalInput = '';
  }

  Uint8List image;
  int counter = 0;
  int indexReadAnalog = 0;
  BigInt result = BigInt.from(0);
  int analogInput = 0;
  String lastDigitalInput = '';

  Future<bool> wsconnect() async {
    try {
      clearOutputValues();
      clearSolenoidState();
      clearStepperMotorState();
      cleardcMotorState();
      clearinputState();

      missedPing = 0;
      lastDigitalInput = '';
      status = Status.socketConnected;

      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
      );

      if (_channel == null) {
        disconnect('Socket failed');
        return false;
      } else {
        _channel.stream.listen((message) {
          debugPrint('rx:$message');

          // ---------------------------------------------------------------------------
          // to test the image send & receive + polling with an echo server:
          // docker run -d -p 8080:8080 inanimate/echo-server
          // ---------------------------------------------------------------------------

          // if (message.toString().startsWith("Request served")) {
          //   return;
          // }
          // var s = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
          // if (message == 'CMD_ReadDigitalInput@Main#') {
          //   message = 'END_ReadDigitalInput@Main(0x$s)';
          // } else if (message.toString().startsWith('CMD_InvertImage')) {
          //   message = message.toString().replaceFirst('CMD', 'END');
          // } else if (message.toString().startsWith('CMD_')) {
          //   message = 'END_ReadAnalogInput@Main(0x$s)';
          // }
          // Timer tevt = Timer.periodic(const Duration(seconds: 15), (Timer t) =>
          //   send('EVT_StopStepperMotor@Main(3)')
          // );

          // ---------------------------------------------------------------------------
          // ---------------------------------------------------------------------------

          try {
            final match = endRegExp.firstMatch(message);
            switch (match[1]) {
              case 'END':
                switch (match[2]) {
                  case 'ReadAnalogInput':
                    missedPing--; // retrig the polling: keep alive the connection
                    inputState[indexReadAnalog] = int.parse(match[5]);
                    if (lastinputState[indexReadAnalog] !=
                        inputState[indexReadAnalog]) {
                      lastinputState[indexReadAnalog] =
                          inputState[indexReadAnalog];
                      notifyListeners();
                    }
                    if (indexReadAnalog >= 4) {
                      indexReadAnalog = 0;
                    } else {
                      indexReadAnalog++;
                    }
                    break;
                  case 'ReadDigitalInput':
                    missedPing--; // retrig the polling: keep alive the connection
                    if (match[5] != lastDigitalInput) {
                      result = BigInt.parse(match[5].split('x')[1], radix: 16);
                      notifyListeners();
                      lastDigitalInput = match[5];
                    }
                    break;
                  case 'InvertImage':
                    image = base64.decode(match[6]);
                    notifyListeners();
                    break;
                  case 'ReadConfiguration':
                    configText = match[7];
                    notifyListeners();
                    break;
                  default:
                    debugPrint("listened: " + message);
                    break;
                }
                break;
              case 'EVT':
                switch (match[2]) {
                  case 'StopStepperMotor':
                    var stepno = int.parse(match[5]);
                    setStepperMotorState(stepno, false);
                    break;
                  default:
                    debugPrint("listened: " + message);
                    break;
                }
            }
          } catch (e) {
            debugPrint(e.toString());
            disconnect('unknown reply from client');
          }
        }, onDone: () {
          disconnect(''); // no text, so disconnect anyway, but we are happy
        }, onError: (e) {
          debugPrint(e.toString());
          // try to format a pretty text (just a try)
          var whole = e.toString().split(':');
          var idx = whole.indexWhere((e) => !e.endsWith("Exception"));
          var msg = whole.sublist(idx).join(':');
          disconnect(msg);
        });
      }
      return true;
    } catch (e) {
      debugPrint('error ${e.toString()}');
      var msg = e.toString().split(':').last;
      disconnect(msg);
      return false;
    }
  }

  Future<void> disconnect(String message) async {
    // alredy disconnected?
    if (status != Status.socketConnected) {
      return;
    }

    if (message.isEmpty) {
      // user disconnects
      status = Status.socketNotConnected;
    } else {
      // something bad happened
      status = Status.socketCrash;
      scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(message),
                )
              ])));
    }

    try {
      _channel.sink.close(); // trigger listen onDone
    } catch (e) {
      debugPrint('sink.close error: ${e.toString()}');
    }
  }

  void send(String data) {
    debugPrint('tx:$data');
    try {
      _channel.sink.add(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
