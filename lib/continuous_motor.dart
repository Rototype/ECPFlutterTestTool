import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getDcMotorButtons(int i, bool active) {
  return TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          Hero(
            tag: 'hero $i',
            child: active
                ? const Icon(Icons.autorenew, color: Colors.red)
                : const Icon(Icons.autorenew, color: Colors.green),
          ),
          Text('M ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/DCMotorPage',
          arguments: i);
    },
  );
}

dynamic dcMotorButtons;

class DCMotor extends StatelessWidget {
  const DCMotor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wsc = Provider.of<WebSocketClass>(context, listen: false);
    dcMotorButtons = List.generate(WebSocketClass.dcMotorStateSize,
        (i) => getDcMotorButtons(i, wsc.getdcMotorState(i)));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('DC Motor'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: dcMotorButtons,
              )));
    });
  }
}

class DCMotorPage extends StatefulWidget {
  const DCMotorPage({Key key}) : super(key: key);

  @override
  _DCMotorPageState createState() => _DCMotorPageState();
}

class _DCMotorPageState extends State<DCMotorPage> {
  double pwm = 33;
  bool isPwmChecked = false;
  double pwmFreq = 50;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' DC Motor ${index + 1}'),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  width: 350.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Hero(
                          tag: 'hero $index',
                          child: user.getdcMotorState(index)
                              ? const Icon(Icons.autorenew,
                                  color: Colors.red, size: 100)
                              : const Icon(Icons.autorenew,
                                  color: Colors.green, size: 100),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Run Clockwise',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (!isPwmChecked) {
                              user.send('CMD_SetDCMotorPWM@Main($index,1,100,20)');
                            } else {
                              user.send(
                                  'CMD_SetDCMotorPWM@Main($index,1,${pwm.toInt()},${pwmFreq.toInt()})');
                            }
                            user.setdcMotorState(index, true);
                            dcMotorButtons[index] =
                                getDcMotorButtons(index, true);
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Run Counter Clockwise',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (!isPwmChecked) {
                              user.send('CMD_SetDCMotorPWM@Main($index,-1,100,20)');
                            } else {
                              user.send(
                                  'CMD_SetDCMotorPWM@Main($index,-1,${pwm.toInt()},${pwmFreq.toInt()})');
                            }
                            user.setdcMotorState(index, true);
                            dcMotorButtons[index] =
                                getDcMotorButtons(index, true);
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Off',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            user.send('CMD_SetDCMotor@Main($index,0)');
                            user.setdcMotorState(index, false);
                            dcMotorButtons[index] =
                                getDcMotorButtons(index, false);
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Brake',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            user.send('CMD_SetDCMotor@Main($index,brake)');
                            user.setdcMotorState(index, false);
                            dcMotorButtons[index] =
                                getDcMotorButtons(index, false);
                          },
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                            title: const Text('Enable PWM:'),
                            value: isPwmChecked,
                            onChanged: (bool newValue) {
                              setState(() => isPwmChecked = newValue);
                            }),
                        Text('Duty cycle: ${pwm.round()}%'),
                        Slider(
                          label: '${pwm.round()}%',
                          value: pwm,
                          onChanged: !isPwmChecked
                              ? null
                              : (newValue) {
                                  setState(() => pwm = newValue);
                                },
                          min: 20,
                          max: 100,
                          divisions: (100 - 20),
                        ),
                        Text('frequency: ${pwmFreq.round()} KHz'),
                        Slider(
                          label: '${pwmFreq.round()} KHz',
                          value: pwmFreq,
                          onChanged: !isPwmChecked
                              ? null
                              : (newValue) {
                                  setState(() {
                                    pwmFreq = newValue;
                                  });
                                },
                          min: 20,
                          max: 100,
                          divisions: ((100 - 20) ~/ 5),
                        ),
                      ]))));
    });
  }
}
