import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

class Solenoid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Solenoids'),
          ),
          body: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                    width: 200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: user.solenoidButtons.length,
                        itemBuilder: (_, int index) {
                          return user.solenoidButtons[index].button;
                        }))
              ])));
    });
  }
}

class SolenoidPage extends StatefulWidget {
  @override
  _SolenoidPageState createState() => _SolenoidPageState();
}

class _SolenoidPageState extends State<SolenoidPage> {
  double pwm = 0;
  double inittime = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Solenoid ${user.index}'),
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      
                      onPressed: () {
                        if (isChecked) {
                          user.send(
                              'CMD_SetDCSolenoidPWM@Main(${user.index - 1},1,$pwm,$inittime)');
                        } else {
                          user.send(
                              'CMD_SetDCSolenoid@Main(${user.index - 1},1)');
                        }
                      },
                      child: Text('Set Solenoid ON',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                    child: ElevatedButton(
                      
                      onPressed: () {
                        user.send(
                            'CMD_SetDCSolenoid@Main(${user.index - 1},0)');
                      },
                      child: Text('Set Solenoid OFF',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Text('Enable PWM: ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool newValue) {
                            setState(() {
                              isChecked = newValue;
                            });
                          },
                        ),
                        isChecked
                            ? Column(
                                children: <Widget>[
                                  Container(
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
                                        Text('PWM: ${pwm.round()}%',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    child: Row(
                                      children: <Widget>[
                                        Slider(
                                          value: inittime,
                                          onChanged: (newValue) {
                                            setState(() {
                                              inittime = newValue;
                                            });
                                          },
                                          min: 0,
                                          max: 2000,
                                          divisions: 100,
                                        ),
                                        Text(
                                            'Init Time: ${inittime.round()} ms',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  Slider(
                                    value: pwm,
                                    onChanged: null,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                  ),
                                  Slider(
                                    value: inittime,
                                    onChanged: null,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
