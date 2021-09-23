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
            child: active ? const Icon(Icons.autorenew, color: Colors.red) : const Icon(Icons.autorenew, color: Colors.green),
          ),
          Text('M ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/DCMotorPage', arguments: i);
    },
  );
}

dynamic dcMotorButtons;

class DCMotor extends StatelessWidget {
  const DCMotor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wsc = Provider.of<WebSocketClass>(context, listen: false);
    dcMotorButtons = List.generate(WebSocketClass.dcMotorStateSize, (i) => getDcMotorButtons(i, wsc.getdcMotorState(i)));

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
  double pwm = 0;
  bool isChecked = false;
  double value = 20000;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' DC Motor ${index + 1}'),
          ),
          body: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'hero $index',
                    child: user.getdcMotorState(index) ? const Icon(Icons.autorenew, color: Colors.red, size: 100) : const Icon(Icons.autorenew, color: Colors.green, size: 100),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: const Text('Off', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              user.send('CMD_SetDCMotor@Main($index,0)');
                              user.setdcMotorState(index, false);
                              dcMotorButtons[index] = getDcMotorButtons(index, false);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              user.send('CMD_SetDCMotor@Main($index,brake)');
                              user.setdcMotorState(index, false);
                              dcMotorButtons[index] = getDcMotorButtons(index, false);
                            },
                            child: const Text('Brake', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 210,
                              child: ElevatedButton(
                                child: const Text('Run Clockwise', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  if (!isChecked) {
                                    user.send('CMD_SetDCMotor@Main($index,1)');
                                  } else {
                                    user.send('CMD_SetDCMotorPWM@Main($index,1,$pwm,$value)');
                                  }
                                  user.setdcMotorState(index, true);
                                  dcMotorButtons[index] = getDcMotorButtons(index, true);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 210,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!isChecked) {
                                    user.send('CMD_SetDCMotor@Main($index,-1)');
                                  } else {
                                    user.send('CMD_SetDCMotorPWM@Main($index,-1,$pwm,$value)');
                                  }
                                  user.setdcMotorState(index, true);
                                  dcMotorButtons[index] = getDcMotorButtons(index, true);
                                },
                                child: const Text('Run Counter Clockwise', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Enable PWM: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool newValue) {
                              setState(() {
                                isChecked = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      if (isChecked)
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 350,
                              child: Row(
                                children: <Widget>[
                                  Slider(
                                    value: pwm,
                                    onChanged: (newValue) {
                                      setState(() {
                                        pwm = newValue;
                                      });
                                    },
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                  ),
                                  Text('PWM: ${pwm.round()}%', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              child: Row(
                                children: <Widget>[
                                  Slider(
                                    value: value,
                                    onChanged: (newValue) {
                                      setState(() {
                                        value = newValue;
                                      });
                                    },
                                    min: 20000,
                                    max: 100000,
                                    divisions: 16,
                                  ),
                                  Text('PWM: ${value.round()} Hz', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: <Widget>[
                            Slider(
                              value: pwm,
                              onChanged: null,
                              min: 0,
                              max: 100,
                              divisions: 100,
                            ),
                            Slider(
                              value: value,
                              onChanged: null,
                              min: 20000,
                              max: 100000,
                              divisions: 16,
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ],
          ));
    });
  }
}
