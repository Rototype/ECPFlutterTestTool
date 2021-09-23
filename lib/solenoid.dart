import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getSolenoidButtons(int i, bool active) {
  return TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          Hero(
            tag: 'hero $i',
            child: active ? const Icon(Icons.sync_alt, color: Colors.red) : const Icon(Icons.sync_alt, color: Colors.green),
          ),
          Text('S ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/SolenoidPage', arguments: i);
    },
  );
}

dynamic solenoidButtons;

class Solenoid extends StatelessWidget {
  const Solenoid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wsc = Provider.of<WebSocketClass>(context, listen: false);
    solenoidButtons = List.generate(WebSocketClass.solenoidStateSize, (i) => getSolenoidButtons(i, wsc.getSolenoidState(i)));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Solenoids'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: solenoidButtons,
              )));
    });
  }
}

class SolenoidPage extends StatefulWidget {
  const SolenoidPage({Key key}) : super(key: key);

  @override
  _SolenoidPageState createState() => _SolenoidPageState();
}

class _SolenoidPageState extends State<SolenoidPage> {
  double pwm = 0;
  double inittime = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Solenoid ${index + 1}'),
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'hero $index',
                    child: user.getSolenoidState(index) ? const Icon(Icons.sync_alt, color: Colors.red, size: 100) : const Icon(Icons.sync_alt, color: Colors.green, size: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (isChecked) {
                          user.send('CMD_SetDCSolenoidPWM@Main($index,1,${pwm.toInt()},${inittime.toInt()})');
                        } else {
                          user.send('CMD_SetDCSolenoid@Main($index,1)');
                        }
                        user.setSolenoidState(index, true);
                        solenoidButtons[index] = getSolenoidButtons(index, true);
                      },
                      child: const Text('Set Solenoid ON',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        user.send('CMD_SetDCSolenoid@Main($index,0)');
                        user.setSolenoidState(index, false);
                        solenoidButtons[index] = getSolenoidButtons(index, false);
                      },
                      child: const Text('Set Solenoid OFF',
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
                        const Text('Enable PWM: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                                        Text('Init Time: ${inittime.round()} ms', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
