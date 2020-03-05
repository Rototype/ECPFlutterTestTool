import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class MotorST extends StatelessWidget {
  const MotorST({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Stepper Motors'),
          ),
          body: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                    width: 200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: user.stepperMotorButtons.length,
                        itemBuilder: (_, int index) {
                          return user.stepperMotorButtons[index].button;
                        }))
              ])));
    });
  }
}

class MotorStPage extends StatefulWidget {
  MotorStPage({Key key}) : super(key: key);

  @override
  _MotorStPageState createState() => _MotorStPageState();
}

class _MotorStPageState extends State<MotorStPage> {
  double acc = 0;

  double spd1 = 0;
  double spd3 = 0;

  double spd21 = 0;
  double spd22 = 0;

  double initSpd = 0;

  double steps1 = 0;
  double steps2 = 0;

  String title = "Continuous";
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;

      if (index == 0) {
        title = "Continuous";
      }
      if (index == 1) {
        title = "Stepper";
      }
      if (index == 2) {
        title = "Configuration";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Stepper Motor ${user.index}:  $title'),
        ),
        body: Row(
          children: <Widget>[
            currentIndex == 0
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: RaisedButton(
                                child: Text('Motor Start',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  user.send(
                                      'CMD_SetStepperMotorSpeed@Main(${user.index - 1},1,$spd1,$acc,50)');
                                },
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: 100,
                                          child: Text(
                                              'Speed: ${spd1.round()}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Slider(
                                        value: spd1,
                                        onChanged: (newSpd) {
                                          setState(() => spd1 = newSpd);
                                        },
                                        min: -100,
                                        max: 100,
                                        divisions: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: RaisedButton(
                                child: Text('Motor Stop',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  user.send(
                                      'CMD_SetStepperMotorSpeed@Main(${user.index - 1},1,0,$acc,50)');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: RaisedButton(
                                child: Text('Motor Speed Change',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  user.send(
                                      'CMD_SetStepperMotorSpeed@Main(${user.index - 1},1,$spd3,$acc,50)');
                                },
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: 100,
                                          child: Text(
                                              'Speed: ${spd3.round()}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Slider(
                                        value: spd3,
                                        onChanged: (newSpd3) {
                                          setState(() => spd3 = newSpd3);
                                        },
                                        min: 0,
                                        max: 100,
                                        divisions: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : currentIndex == 1
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: RaisedButton(
                                    child: Text('Execute const Speed',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      user.send(
                                          'CMD_SetStepperMotorCountSteps@Main(${user.index - 1},1,$spd21,0,50,$steps2)');
                                    },
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: 100,
                                              child: Text(
                                                  'Max Speed: ${spd21.round()}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Slider(
                                            value: spd21,
                                            onChanged: (newSpd21) {
                                              setState(() => spd21 = newSpd21);
                                            },
                                            min: -100,
                                            max: 100,
                                            divisions: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: 100,
                                              child: Text(
                                                  'Steps: ${steps1.round()}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Slider(
                                            value: steps1,
                                            onChanged: (newsteps1) {
                                              setState(
                                                  () => steps1 = newsteps1);
                                            },
                                            min: 0,
                                            max: 100,
                                            divisions: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: RaisedButton(
                                    child: Text('Execute at Max Speed',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      user.send(
                                          'CMD_SetStepperMotorCountSteps@Main(${user.index - 1},1,$spd22,$acc,50,$steps2)');
                                    },
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: 100,
                                              child: Text(
                                                  'Max Speed: ${spd22.round()}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Slider(
                                            value: spd22,
                                            onChanged: (newspd22) {
                                              setState(() => spd22 = newspd22);
                                            },
                                            min: 0,
                                            max: 100,
                                            divisions: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: 100,
                                              child: Text(
                                                  'Steps: ${steps2.round()}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Slider(
                                            value: steps2,
                                            onChanged: (newSteps2) {
                                              setState(
                                                  () => steps2 = newSteps2);
                                            },
                                            min: 0,
                                            max: 100,
                                            divisions: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 200,
                                      child: Text(
                                          'Accelleration : ${acc.round()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                  Slider(
                                    value: acc,
                                    onChanged: (newAcc21) {
                                      setState(() => acc = newAcc21);
                                    },
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 200,
                                      child: Text(
                                          'Initial Speed : ${initSpd.round()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                  Slider(
                                    value: initSpd,
                                    onChanged: (newinitSpd) {
                                      setState(() => initSpd = newinitSpd);
                                    },
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text('Continous'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text('Steps'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications),
              title: Text('Configuration'),
            )
          ],
          selectedItemColor: Colors.red[800],
          currentIndex: currentIndex,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
