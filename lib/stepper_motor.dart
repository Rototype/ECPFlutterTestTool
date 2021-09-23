import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getStepperMotorButtons(int i, bool active) {
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
      Navigator.pushNamed(_scaffoldKey.currentContext, '/StepperMotorPage', arguments: i);
    },
  );
}

dynamic stepperMotorButtons;

class MotorST extends StatelessWidget {
  const MotorST({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    stepperMotorButtons = List.generate(WebSocketClass.stepperMotorStateSize, (i) => getStepperMotorButtons(i, false));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Stepper Motors'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: stepperMotorButtons,
              )));
    });
  }
}

class MotorStPage extends StatefulWidget {
  const MotorStPage({Key key}) : super(key: key);

  @override
  _MotorStPageState createState() => _MotorStPageState();
}

class _MotorStPageState extends State<MotorStPage> {
  double maxacc = 0;

  TextEditingController controllerSpeedChange = TextEditingController();
  TextEditingController controllerMotorStart = TextEditingController();
  TextEditingController controllerExConst = TextEditingController();
  TextEditingController controllerExConst2 = TextEditingController();
  TextEditingController controllerExMax = TextEditingController();
  TextEditingController controllerExMax2 = TextEditingController();
  TextEditingController controllerMaxAcc = TextEditingController();
  TextEditingController controllerInit = TextEditingController();

  String resolution2 = "1";

  double spd1 = 80;
  double spd3 = 80;

  double spd21 = 80;
  double spd22 = 80;

  double initSpd = 80;

  double steps1 = 1;
  double steps2 = 1;

  double load = 50;

  double resolution = 1;

  String title = "Continuous";
  int currentIndex = 0;

  bool isStartedPositive = false;
  bool isStartedNegative = false;

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
    final index = ModalRoute.of(context).settings.arguments as int;

    controllerMotorStart.text = spd1.toString();
    controllerSpeedChange.text = spd3.toString();
    controllerExConst.text = spd21.toString();
    controllerExConst2.text = steps1.toString();
    controllerExMax.text = spd22.toString();
    controllerMaxAcc.text = maxacc.toString();
    controllerInit.text = initSpd.toString();
    controllerExMax2.text = steps2.toString();

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      var childrenConstSpeedMobile = <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              width: 400,
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: 155,
                      child: Row(
                        children: <Widget>[
                          const Text("Speed: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 100,
                            child: TextField(
                                onChanged: (newString) {
                                  if (double.parse(newString) > 80000 || double.parse(newString) < -80000) {
                                    if (double.parse(newString) < 0) {
                                      controllerMotorStart.text = (-80000).toString();
                                      spd1 = -80000;
                                    } else {
                                      controllerMotorStart.text = (80000).toString();
                                      spd1 = 80000;
                                    }
                                  }
                                },
                                onEditingComplete: () {
                                  if (double.parse(controllerMotorStart.text) > -80 && double.parse(controllerMotorStart.text) < 80) {
                                    if (double.parse(controllerMotorStart.text) <= 0) {
                                      controllerMotorStart.text = (-80).toString();
                                      spd1 = -80;
                                    } else {
                                      controllerMotorStart.text = (80).toString();
                                      spd1 = 80;
                                    }
                                  }
                                  try {
                                    spd1 = double.parse(controllerMotorStart.text);
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    spd1 = 80;
                                  }
                                },
                                maxLength: 10,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                controller: controllerMotorStart,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 150,
                    child: Slider(
                      value: spd1,
                      onChanged: (newSpd1) {
                        if (newSpd1 > -80 && newSpd1 < 80) {
                          if (newSpd1 < 0) {
                            newSpd1 = -80;
                          } else {
                            newSpd1 = 80;
                          }
                        }
                        controllerMotorStart.text = (newSpd1.round()).toString();
                        setState(() => spd1 = double.parse(newSpd1.round().toString()));
                      },
                      min: -80000,
                      max: 80000,
                      divisions: 80000,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: (isStartedNegative == false && isStartedPositive == false)
                  ? ElevatedButton(
                      child: const Text('Motor Start', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (spd1 > 0) {
                          spd3 = 80;
                          setState(() => isStartedPositive = true);
                        } else {
                          spd3 = -80;
                          setState(() => isStartedNegative = true);
                        }
                        user.send('CMD_SetStepperMotorSpeed@Main($index,$resolution2,$spd1,$maxacc,$load)');
                        stepperMotorButtons[index] = getStepperMotorButtons(index, true);
                        user.setStepperMotorState(index, true);
                      },
                    )
                  : const ElevatedButton(child: Text('Motor Start', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), onPressed: null),
            ),
          ],
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          title: Text(' Stepper Motor ${index + 1}:  $title'),
        ),
        body: currentIndex == 0
            ? ListView(scrollDirection: Axis.vertical, children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Hero(
                          tag: 'hero $index',
                          child: user.getStepperMotorState(index) ? 
                              const Icon(Icons.autorenew, color: Colors.red, size: 100) 
                            : const Icon(Icons.autorenew, color: Colors.green, size: 100)),
                        Padding(padding: const EdgeInsets.all(5.0), child: Column(children: childrenConstSpeedMobile)),
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 250,
                                  child: ElevatedButton(
                                    child: const Text('Motor Stop', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      setState(() => isStartedNegative = false);
                                      setState(() => isStartedPositive = false);

                                      user.send('CMD_SetStepperMotorSpeed@Main($index,$resolution2,0,$maxacc,$load)');
                                      stepperMotorButtons[index] = getStepperMotorButtons(index, false);
                                      user.setStepperMotorState(index, false);

                                    },
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )
                  ],
                )
              ])
            : currentIndex == 1
                ? ListView(scrollDirection: Axis.vertical, children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Hero(
                              tag: 'hero $index',
                              child: user.getStepperMotorState(index) ? 
                                const Icon(Icons.autorenew, color: Colors.red, size: 100) 
                              : const Icon(Icons.autorenew, color: Colors.green, size: 100)),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: 400,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(40, 30, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 155,
                                                child: Row(
                                                  children: <Widget>[
                                                    const Text('Steps: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                    SizedBox(
                                                      width: 100,
                                                      child: TextField(
                                                          onChanged: (newString) {
                                                            if (double.parse(newString) > pow(2, 32) - 1 || double.parse(newString) < -pow(2, 32) + 1) {
                                                              if (double.parse(newString) < 0) {
                                                                controllerExConst2.text = (pow(2, 32) - 1).toString();
                                                                steps1 = pow(2, 32) - 1;
                                                              } else {
                                                                controllerExConst2.text = (-pow(2, 32) + 1).toString();
                                                                steps1 = -pow(2, 32) + 1;
                                                              }
                                                            }
                                                          },
                                                          onEditingComplete: () {
                                                            if (double.parse(controllerExConst2.text) > 1 && double.parse(controllerExConst2.text) < 1) {
                                                              controllerExConst2.text = (1).toString();
                                                              steps1 = 1;
                                                            }
                                                            try {
                                                              steps1 = double.parse(controllerExConst2.text);
                                                            } catch (e) {
                                                              debugPrint(e.toString());
                                                              steps1 = 1;
                                                            }
                                                          },
                                                          maxLength: 10,
                                                          decoration: const InputDecoration(
                                                            counterText: "",
                                                            border: InputBorder.none,
                                                          ),
                                                          controller: controllerExConst2,
                                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Slider(
                                                  value: steps1,
                                                  onChanged: (newsteps1) {
                                                    controllerExConst2.text = newsteps1.toString();
                                                    setState(() => steps1 = newsteps1.roundToDouble());
                                                  },
                                                  min: (-(pow(2, 32)) + 1).toDouble(),
                                                  max: (pow(2, 32) - 1).toDouble(),
                                                  divisions: pow(2, 32) - 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 155,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Text("Speed: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                            onChanged: (newString) {
                                                              if (double.parse(newString) > 80000) {
                                                                controllerExConst.text = (80000).toString();
                                                                spd21 = 80000;
                                                              }
                                                            },
                                                            onEditingComplete: () {
                                                              if (double.parse(controllerExConst.text) > 80000 || double.parse(controllerExConst.text) < 80) {
                                                                controllerExConst.text = (80).toString();
                                                                spd21 = 80;
                                                              }
                                                              try {
                                                                spd21 = double.parse(controllerExConst.text);
                                                              } catch (e) {
                                                                debugPrint(e.toString());
                                                                spd21 = 80;
                                                              }
                                                            },
                                                            maxLength: 10,
                                                            decoration: const InputDecoration(
                                                              counterText: "",
                                                              border: InputBorder.none,
                                                            ),
                                                            controller: controllerExConst,
                                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 150,
                                                child: Slider(
                                                  value: spd21,
                                                  onChanged: (newSpd21) {
                                                    controllerExConst.text = newSpd21.toString();
                                                    setState(() => spd21 = newSpd21.roundToDouble());
                                                  },
                                                  min: 80,
                                                  max: 80000,
                                                  divisions: 80000 - 80,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      child: const Text('Execute constant Speed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        user.send('CMD_SetStepperMotorCountSteps@Main($index,$resolution2,$spd21,0,$load,$steps1)');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: 400,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 155,
                                                child: Row(
                                                  children: <Widget>[
                                                    const Text('Steps: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                    SizedBox(
                                                      width: 100,
                                                      child: TextField(
                                                          onChanged: (newString) {
                                                            if (double.parse(newString) > pow(2, 32) - 1 || double.parse(newString) < -pow(2, 32) + 1) {
                                                              if (double.parse(newString) < 0) {
                                                                controllerExMax2.text = (pow(2, 32) - 1).toString();
                                                                steps2 = pow(2, 32) - 1;
                                                              } else {
                                                                controllerExMax2.text = (-pow(2, 32) + 1).toString();
                                                                steps2 = -pow(2, 32) + 1;
                                                              }
                                                            }
                                                          },
                                                          onEditingComplete: () {
                                                            if (double.parse(controllerExMax2.text) > 1 && double.parse(controllerExMax2.text) < 1) {
                                                              controllerExMax2.text = (1).toString();
                                                              steps2 = 1;
                                                            }
                                                            try {
                                                              steps2 = double.parse(controllerExMax2.text);
                                                            } catch (e) {
                                                              debugPrint(e.toString());
                                                              steps2 = 1;
                                                            }
                                                          },
                                                          maxLength: 10,
                                                          decoration: const InputDecoration(
                                                            counterText: "",
                                                            border: InputBorder.none,
                                                          ),
                                                          controller: controllerExMax2,
                                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Slider(
                                                  value: steps2,
                                                  onChanged: (newSteps2) {
                                                    setState(() => steps2 = newSteps2.roundToDouble());
                                                  },
                                                  min: (-pow(2, 32) + 1).toDouble(),
                                                  max: (pow(2, 32) - 1).toDouble(),
                                                  divisions: pow(2, 32) - 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 155,
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Text("Speed: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                            onChanged: (newString) {
                                                              if (double.parse(newString) > 80000) {
                                                                controllerExMax.text = (80000).toString();
                                                                spd22 = 80000;
                                                              }
                                                            },
                                                            onEditingComplete: () {
                                                              if (double.parse(controllerExMax.text) > 80000 || double.parse(controllerExMax.text) < 80) {
                                                                controllerExMax.text = (80).toString();
                                                                spd22 = 80;
                                                              }
                                                              try {
                                                                spd22 = double.parse(controllerExMax.text);
                                                              } catch (e) {
                                                                debugPrint(e.toString());
                                                                spd22 = 80;
                                                              }
                                                            },
                                                            maxLength: 10,
                                                            decoration: const InputDecoration(
                                                              counterText: "",
                                                              border: InputBorder.none,
                                                            ),
                                                            controller: controllerExMax,
                                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 150,
                                                child: Slider(
                                                  value: spd22,
                                                  onChanged: (newSpd22) {
                                                    controllerExMax.text = newSpd22.toString();
                                                    setState(() => spd22 = newSpd22.roundToDouble());
                                                  },
                                                  min: 80,
                                                  max: 80000,
                                                  divisions: 80000 - 80,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      child: const Text('Execute at Max Speed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        user.send('CMD_SetStepperMotorCountSteps@Main($index,$resolution2,$spd22,$maxacc,$load,$steps2)');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ])
                : ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Hero(
                                tag: 'hero $index',
                                child: user.getStepperMotorState(index) ? 
                                  const Icon(Icons.autorenew, color: Colors.red, size: 100) 
                                : const Icon(Icons.autorenew, color: Colors.green, size: 100)),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: Row(
                                          children: <Widget>[
                                            const Text(" Max Acceleration: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            SizedBox(
                                              width: 100,
                                              child: TextField(
                                                  onChanged: (newString) {
                                                    if (double.parse(newString) > 2097151 || double.parse(newString) < 0) {
                                                      controllerMaxAcc.text = "1";
                                                      maxacc = 1;
                                                    }
                                                  },
                                                  onEditingComplete: () {
                                                    try {
                                                      maxacc = double.parse(controllerMaxAcc.text);
                                                    } catch (e) {
                                                      maxacc = 1;
                                                    }
                                                  },
                                                  maxLength: 10,
                                                  decoration: const InputDecoration(
                                                    counterText: "",
                                                    border: InputBorder.none,
                                                  ),
                                                  controller: controllerMaxAcc,
                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 300,
                                      child: Slider(
                                        value: maxacc,
                                        onChanged: (controllerMaxAcc1) {
                                          controllerMaxAcc.text = controllerMaxAcc1.toString();
                                          setState(() => maxacc = controllerMaxAcc1);
                                        },
                                        min: 0,
                                        max: 2097151,
                                        divisions: 2097151,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: Row(
                                          children: <Widget>[
                                            const Text("Initial Speed: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            SizedBox(
                                              width: 100,
                                              child: TextField(
                                                  onChanged: (newString) {
                                                    if (double.parse(newString) > 80000 || double.parse(newString) < 80) {
                                                      controllerInit.text = "80";
                                                      initSpd = 80;
                                                    }
                                                  },
                                                  onEditingComplete: () {
                                                    try {
                                                      initSpd = double.parse(controllerInit.text);
                                                    } catch (e) {
                                                      initSpd = 1;
                                                    }
                                                  },
                                                  maxLength: 10,
                                                  decoration: const InputDecoration(
                                                    counterText: "",
                                                    border: InputBorder.none,
                                                  ),
                                                  controller: controllerInit,
                                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 300,
                                      child: Slider(
                                        value: initSpd,
                                        onChanged: (controllerInit1) {
                                          controllerInit.text = controllerInit1.roundToDouble().toString();
                                          setState(() => initSpd = controllerInit1.roundToDouble());
                                        },
                                        min: 80,
                                        max: 80000,
                                        divisions: 80000 - 80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: Row(
                                          children: <Widget>[
                                            Text("Resolution: $resolution2", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ],
                                        )),
                                    Slider(
                                      value: resolution,
                                      onChanged: (newResolution) {
                                        if (newResolution.roundToDouble() == 1) {
                                          resolution2 = "1";
                                        }
                                        if (newResolution.roundToDouble() == 6) {
                                          resolution2 = "2";
                                        }
                                        if (newResolution.roundToDouble() == 11) {
                                          resolution2 = "8";
                                        }
                                        if (newResolution.roundToDouble() == 16) {
                                          resolution2 = "16";
                                        }
                                        setState(() => resolution = newResolution.roundToDouble());
                                      },
                                      min: 1,
                                      max: 16,
                                      divisions: 3,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: Row(
                                          children: <Widget>[
                                            Text("Load: $load%", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ],
                                        )),
                                    Slider(
                                      value: load,
                                      onChanged: (load1) {
                                        setState(() => load = load1);
                                      },
                                      min: 50,
                                      max: 100,
                                      divisions: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: ('Continuous'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: ('Steps'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications),
              label: ('Configuration'),
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
