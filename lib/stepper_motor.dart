import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  TextEditingController controllerSpeedChange = new TextEditingController();
  TextEditingController controllerMotorStart = new TextEditingController();
  TextEditingController controllerExConst = new TextEditingController();
  TextEditingController controllerExConst2 = new TextEditingController();
  TextEditingController controllerExMax = new TextEditingController();
  TextEditingController controllerExMax2 = new TextEditingController();
  TextEditingController controllerMaxAcc = new TextEditingController();
  TextEditingController controllerInit = new TextEditingController();

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
    controllerMotorStart.text = spd1.toString();
    controllerSpeedChange.text = spd3.toString();
    controllerExConst.text = spd21.toString();
    controllerExConst2.text = steps1.toString();
    controllerExMax.text = spd22.toString();
    controllerMaxAcc.text = acc.toString();
    controllerInit.text = initSpd.toString();
    controllerExMax2.text = steps2.toString();

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Stepper Motor ${user.index}:  $title'),
        ),
        body: Center(
            child: currentIndex == 0
                ? Container(
                    width: 300,
                    height: 400,
                    child:
                        ListView(
                          scrollDirection: Axis.horizontal, 
                          children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: (isStartedNegative == false &&
                                          isStartedPositive == false)
                                      ? RaisedButton(
                                          color: Colors.indigo[50],
                                          child: Text('Motor Start',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            if (spd1 > 0) {
                                              spd3 = 80;
                                              setState(() =>
                                                  isStartedPositive = true);
                                            } else {
                                              spd3 = -80;
                                              setState(() =>
                                                  isStartedNegative = true);
                                            }
                                            user.send(
                                                'CMD_SetStepperMotorSpeed@Main(${user.index - 1},$resolution2,$spd1,$acc,$load)');
                                          },
                                        )
                                      : RaisedButton(
                                          color: Colors.indigo[50],
                                          child: Text('Motor Start',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: null),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: 155,
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Speed: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Container(
                                                    width: 100,
                                                    child: TextField(
                                                        onChanged: (newString) {
                                                          if (double.parse(
                                                                      newString) >
                                                                  80000 ||
                                                              double.parse(
                                                                      newString) <
                                                                  -80000) {
                                                            if (double.parse(
                                                                    newString) <
                                                                0) {
                                                              controllerMotorStart
                                                                      .text =
                                                                  (-80000)
                                                                      .toString();
                                                              spd1 = -80000;
                                                            } else {
                                                              controllerMotorStart
                                                                      .text =
                                                                  (80000)
                                                                      .toString();
                                                              spd1 = 80000;
                                                            }
                                                          }
                                                        },
                                                        onEditingComplete: () {
                                                          if (double.parse(
                                                                      controllerMotorStart
                                                                          .text) >
                                                                  -80 &&
                                                              double.parse(
                                                                      controllerMotorStart
                                                                          .text) <
                                                                  80) {
                                                            if (double.parse(
                                                                    controllerMotorStart
                                                                        .text) <=
                                                                0) {
                                                              controllerMotorStart
                                                                      .text =
                                                                  (-80)
                                                                      .toString();
                                                              spd1 = -80;
                                                            } else {
                                                              controllerMotorStart
                                                                      .text =
                                                                  (80).toString();
                                                              spd1 = 80;
                                                            }
                                                          }
                                                          try {
                                                            spd1 = double.parse(
                                                                controllerMotorStart
                                                                    .text);
                                                          } catch (e) {
                                                            print(e);
                                                            spd1 = 80;
                                                          }
                                                        },
                                                        maxLength: 10,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: "",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        controller:
                                                            controllerMotorStart,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              )),
                                          Slider(
                                            value: spd1,
                                            onChanged: (newSpd1) {
                                              if (newSpd1 > -80 &&
                                                  newSpd1 < 80) {
                                                if (newSpd1 < 0) {
                                                  newSpd1 = -80;
                                                } else {
                                                  newSpd1 = 80;
                                                }
                                              }
                                              controllerMotorStart.text =
                                                  (newSpd1.round()).toString();
                                              setState(() => spd1 =
                                                  double.parse(newSpd1
                                                      .round()
                                                      .toString()));
                                            },
                                            min: -80000,
                                            max: 80000,
                                            divisions: 80000,
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
                                    color: Colors.indigo[50],
                                    child: Text('Motor Stop',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      setState(() => isStartedNegative = false);
                                      setState(() => isStartedPositive = false);

                                      user.send(
                                          'CMD_SetStepperMotorSpeed@Main(${user.index - 1},$resolution2,0,$acc,$load)');
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
                                    color: Colors.indigo[50],
                                    child: Text('Motor Speed Change',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      user.send(
                                          'CMD_SetStepperMotorSpeed@Main(${user.index - 1},$resolution2,$spd3,$acc,$load)');
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
                                              width: 155,
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Speed: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Container(
                                                    width: 100,
                                                    child: TextFormField(
                                                        onChanged: (newString) {
                                                          if (isStartedNegative) {
                                                            if (double.parse(
                                                                        newString) >
                                                                    -80 ||
                                                                double.parse(
                                                                        newString) <
                                                                    -80000) {
                                                              controllerSpeedChange
                                                                      .text =
                                                                  (-80)
                                                                      .toString();
                                                              spd3 = -80;
                                                            }
                                                          }
                                                          if (isStartedPositive) {
                                                            if (double.parse(
                                                                        newString) >
                                                                    80000 ||
                                                                double.parse(
                                                                        newString) <
                                                                    80) {
                                                              controllerSpeedChange
                                                                      .text =
                                                                  (80).toString();
                                                              spd3 = 80;
                                                            }
                                                          } else {
                                                            if (double.parse(
                                                                        newString) >
                                                                    80000 ||
                                                                double.parse(
                                                                        newString) <
                                                                    -80000) {
                                                              if (double.parse(
                                                                      newString) <
                                                                  0) {
                                                                controllerSpeedChange
                                                                        .text =
                                                                    (-80000)
                                                                        .toString();
                                                                spd3 = -80000;
                                                              } else {
                                                                controllerSpeedChange
                                                                        .text =
                                                                    (80000)
                                                                        .toString();
                                                                spd3 = 80000;
                                                              }
                                                            }
                                                          }
                                                        },
                                                        onEditingComplete: () {
                                                          if (!isStartedPositive &&
                                                              !isStartedPositive) {
                                                            if (double.parse(
                                                                        controllerSpeedChange
                                                                            .text) >
                                                                    -80 &&
                                                                double.parse(
                                                                        controllerSpeedChange
                                                                            .text) <
                                                                    80) {
                                                              if (double.parse(
                                                                      controllerSpeedChange
                                                                          .text) <=
                                                                  0) {
                                                                controllerSpeedChange
                                                                        .text =
                                                                    (-80)
                                                                        .toString();
                                                                spd3 = -80;
                                                              } else {
                                                                controllerSpeedChange
                                                                        .text =
                                                                    (80).toString();
                                                                spd3 = 80;
                                                              }
                                                            }
                                                          }
                                                          try {
                                                            spd3 = double.parse(
                                                                controllerSpeedChange
                                                                    .text);
                                                          } catch (e) {
                                                            if (isStartedPositive) {
                                                              print(e);
                                                              spd3 = 80;
                                                            }
                                                            if (isStartedNegative) {
                                                              print(e);
                                                              spd3 = -80;
                                                            } else {
                                                              print(e);
                                                              spd3 = 80;
                                                            }
                                                          }
                                                        },
                                                        maxLength: 10,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: "",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        controller:
                                                            controllerSpeedChange,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              )),
                                          !isStartedNegative &&
                                                  !isStartedPositive
                                              ? Slider(
                                                  value: spd3,
                                                  onChanged: (newSpd3) {
                                                    controllerSpeedChange.text =
                                                        newSpd3.toString();
                                                    setState(() => spd3 =
                                                        newSpd3
                                                            .roundToDouble());
                                                  },
                                                  min: -80000,
                                                  max: 80000,
                                                  divisions: 160000,
                                                )
                                              : isStartedPositive
                                                  ? Slider(
                                                      value: double.parse(
                                                          controllerSpeedChange
                                                              .text),
                                                      onChanged: (newSpd3) {
                                                        controllerSpeedChange
                                                                .text =
                                                            newSpd3.toString();
                                                        setState(() => spd3 =
                                                            double.parse(newSpd3
                                                                .round()
                                                                .toString()));
                                                      },
                                                      min: 80,
                                                      max: 80000,
                                                      divisions: 80000 - 80,
                                                    )
                                                  : Slider(
                                                      value: double.parse(
                                                          controllerSpeedChange
                                                              .text),
                                                      onChanged: (newSpd3) {
                                                        controllerSpeedChange
                                                                .text =
                                                            newSpd3.toString();
                                                        setState(() => spd3 =
                                                            double.parse(newSpd3
                                                                .round()
                                                                .toString()));
                                                      },
                                                      min: -80000,
                                                      max: -80,
                                                      divisions: 80000 - 80,
                                                    )
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
                    ]),
                  )
                : currentIndex == 1
                    ? Container(
                      width: 300,
                      height: 400,
                      child: ListView(
                        scrollDirection: Axis.horizontal, 
                        children: <Widget>[
                          Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 250,
                                        child: RaisedButton(
                                          color: Colors.indigo[50],
                                          child: Text('Execute constant Speed',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            user.send(
                                                'CMD_SetStepperMotorCountSteps@Main(${user.index - 1},$resolution2,$spd21,0,$load,$steps1)');
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
                                                  width: 155,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text('Steps: ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                                      Container(
                                                        width: 100,
                                                        child: TextField(
                                                            onChanged: (newString) {
                                                              if (double.parse(
                                                                          newString) >
                                                                      pow(2, 32) -
                                                                          1 ||
                                                                  double.parse(
                                                                          newString) <
                                                                      -pow(2, 32) +
                                                                          1) {
                                                                if (double.parse(
                                                                        newString) <
                                                                    0) {
                                                                  controllerExConst2
                                                                          .text =
                                                                      (pow(2, 32) - 1)
                                                                          .toString();
                                                                  steps1 =
                                                                      pow(2, 32) - 1;
                                                                } else {
                                                                  controllerExConst2
                                                                          .text =
                                                                      (-pow(2, 32) +
                                                                              1)
                                                                          .toString();
                                                                  steps1 =
                                                                      -pow(2, 32) + 1;
                                                                }
                                                              }
                                                            },
                                                            onEditingComplete: () {
                                                              if (double.parse(
                                                                          controllerExConst2
                                                                              .text) >
                                                                      1 &&
                                                                  double.parse(
                                                                          controllerExConst2
                                                                              .text) <
                                                                      1) {
                                                                controllerExConst2
                                                                        .text =
                                                                    (1).toString();
                                                                steps1 = 1;
                                                              }
                                                              try {
                                                                steps1 = double.parse(
                                                                    controllerExConst2
                                                                        .text);
                                                              } catch (e) {
                                                                print(e);
                                                                steps1 = 1;
                                                              }
                                                            },
                                                            maxLength: 10,
                                                            decoration:
                                                                InputDecoration(
                                                              counterText: "",
                                                              border:
                                                                  InputBorder.none,
                                                            ),
                                                            controller:
                                                                controllerExConst2,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Slider(
                                                  value: steps1,
                                                  onChanged: (newsteps1) {
                                                    controllerExConst2.text =
                                                        newsteps1.toString();
                                                    setState(() => steps1 =
                                                        newsteps1.roundToDouble());
                                                  },
                                                  min: (-(pow(2, 32))+1).toDouble(),
                                                  max: (pow(2, 32) - 1).toDouble(),
                                                  divisions: pow(2, 32) - 2,
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
                                                    width: 155,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("Speed: ",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold)),
                                                        Container(
                                                          width: 100,
                                                          child: TextField(
                                                              onChanged: (newString) {
                                                                if (double.parse(
                                                                        newString) >
                                                                    80000) {
                                                                  controllerExConst
                                                                          .text =
                                                                      (80000)
                                                                          .toString();
                                                                  spd21 = 80000;
                                                                }
                                                              },
                                                              onEditingComplete: () {
                                                                if (double.parse(
                                                                            controllerExConst
                                                                                .text) >
                                                                        80000 ||
                                                                    double.parse(
                                                                            controllerExConst
                                                                                .text) <
                                                                        80) {
                                                                  controllerExConst
                                                                          .text =
                                                                      (80).toString();
                                                                  spd21 = 80;
                                                                }
                                                                try {
                                                                  spd21 = double.parse(
                                                                      controllerExConst
                                                                          .text);
                                                                } catch (e) {
                                                                  print(e);
                                                                  spd21 = 80;
                                                                }
                                                              },
                                                              maxLength: 10,
                                                              decoration:
                                                                  InputDecoration(
                                                                counterText: "",
                                                                border:
                                                                    InputBorder.none,
                                                              ),
                                                              controller:
                                                                  controllerExConst,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    )),
                                                Slider(
                                                  value: spd21,
                                                  onChanged: (newSpd21) {
                                                    controllerExConst.text =
                                                        newSpd21.toString();
                                                    setState(() => spd21 =
                                                        newSpd21.roundToDouble());
                                                  },
                                                  min: 80,
                                                  max: 80000,
                                                  divisions: 80000 - 80,
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
                                        width: 250,
                                        child: RaisedButton(
                                          color: Colors.indigo[50],
                                          child: Text('Execute at Max Speed',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            user.send(
                                                'CMD_SetStepperMotorCountSteps@Main(${user.index - 1},$resolution2,$spd22,$acc,$load,$steps2)');
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
                                                  width: 155,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text('Steps: ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                                      Container(
                                                        width: 100,
                                                        child: TextField(
                                                            onChanged: (newString) {
                                                              if (double.parse(
                                                                          newString) >
                                                                      pow(2, 32) -
                                                                          1 ||
                                                                  double.parse(
                                                                          newString) <
                                                                      -pow(2, 32) +
                                                                          1) {
                                                                if (double.parse(
                                                                        newString) <
                                                                    0) {
                                                                  controllerExMax2
                                                                          .text =
                                                                      (pow(2, 32) - 1)
                                                                          .toString();
                                                                  steps2 =
                                                                      pow(2, 32) - 1;
                                                                } else {
                                                                  controllerExMax2
                                                                          .text =
                                                                      (-pow(2, 32) +
                                                                              1)
                                                                          .toString();
                                                                  steps2 =
                                                                      -pow(2, 32) + 1;
                                                                }
                                                              }
                                                            },
                                                            onEditingComplete: () {
                                                              if (double.parse(
                                                                          controllerExMax2
                                                                              .text) >
                                                                      1 &&
                                                                  double.parse(
                                                                          controllerExMax2
                                                                              .text) <
                                                                      1) {
                                                                controllerExMax2
                                                                        .text =
                                                                    (1).toString();
                                                                steps2 = 1;
                                                              }
                                                              try {
                                                                steps2 = double.parse(
                                                                    controllerExMax2
                                                                        .text);
                                                              } catch (e) {
                                                                print(e);
                                                                steps2 = 1;
                                                              }
                                                            },
                                                            maxLength: 10,
                                                            decoration:
                                                                InputDecoration(
                                                              counterText: "",
                                                              border:
                                                                  InputBorder.none,
                                                            ),
                                                            controller:
                                                                controllerExMax2,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Slider(
                                                  value: steps2,
                                                  onChanged: (newSteps2) {
                                                    setState(() => steps2 =
                                                        newSteps2.roundToDouble());
                                                  },
                                                  min: (-pow(2, 32) + 1).toDouble(),
                                                  max: (pow(2, 32) - 1).toDouble(),
                                                  divisions: pow(2, 32) - 2,
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
                                                    width: 155,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("Speed: ",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold)),
                                                        Container(
                                                          width: 100,
                                                          child: TextField(
                                                              onChanged: (newString) {
                                                                if (double.parse(
                                                                        newString) >
                                                                    80000) {
                                                                  controllerExMax
                                                                          .text =
                                                                      (80000)
                                                                          .toString();
                                                                  spd22 = 80000;
                                                                }
                                                              },
                                                              onEditingComplete: () {
                                                                if (double.parse(
                                                                            controllerExMax
                                                                                .text) >
                                                                        80000 ||
                                                                    double.parse(
                                                                            controllerExMax
                                                                                .text) <
                                                                        80) {
                                                                  controllerExMax
                                                                          .text =
                                                                      (80).toString();
                                                                  spd22 = 80;
                                                                }
                                                                try {
                                                                  spd22 = double.parse(
                                                                      controllerExMax
                                                                          .text);
                                                                } catch (e) {
                                                                  print(e);
                                                                  spd22 = 80;
                                                                }
                                                              },
                                                              maxLength: 10,
                                                              decoration:
                                                                  InputDecoration(
                                                                counterText: "",
                                                                border:
                                                                    InputBorder.none,
                                                              ),
                                                              controller:
                                                                  controllerExMax,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    )),
                                                Slider(
                                                  value: spd22,
                                                  onChanged: (newSpd22) {
                                                    controllerExMax.text =
                                                        newSpd22.toString();
                                                    setState(() => spd22 = newSpd22);
                                                  },
                                                  min: 80,
                                                  max: 80000,
                                                  divisions: 80000 - 80,
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
                            ),
                        ],
                      ),
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
                                      width: 250,
                                      child: Row(
                                        children: <Widget>[
                                          Text(" Max Acceleration: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Container(
                                            width: 100,
                                            child: TextField(
                                                onChanged: (newString) {
                                                  if (double.parse(newString) >
                                                          2097151 ||
                                                      double.parse(newString) <
                                                          0) {
                                                    controllerMaxAcc.text = "1";
                                                    acc = 1;
                                                  }
                                                },
                                                onEditingComplete: () {
                                                  try {
                                                    acc = double.parse(
                                                        controllerMaxAcc.text);
                                                  } catch (e) {
                                                    acc = 1;
                                                  }
                                                },
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  border: InputBorder.none,
                                                ),
                                                controller: controllerMaxAcc,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )),
                                  Slider(
                                    value: acc,
                                    onChanged: (controllerMaxAcc1) {
                                      controllerMaxAcc.text =
                                          controllerMaxAcc1.toString();
                                      setState(() => acc = controllerMaxAcc1);
                                    },
                                    min: 0,
                                    max: 2097151,
                                    divisions: 2097151,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 250,
                                      child: Row(
                                        children: <Widget>[
                                          Text("Initial Speed: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Container(
                                            width: 100,
                                            child: TextField(
                                                onChanged: (newString) {
                                                  if (double.parse(newString) >
                                                          80000 ||
                                                      double.parse(newString) <
                                                          80) {
                                                    controllerInit.text = "80";
                                                    initSpd = 80;
                                                  }
                                                },
                                                onEditingComplete: () {
                                                  try {
                                                    initSpd = double.parse(
                                                        controllerInit.text);
                                                  } catch (e) {
                                                    initSpd = 1;
                                                  }
                                                },
                                                maxLength: 10,
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  border: InputBorder.none,
                                                ),
                                                controller: controllerInit,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )),
                                  Slider(
                                    value: initSpd,
                                    onChanged: (controllerInit1) {
                                      controllerInit.text = controllerInit1
                                          .roundToDouble()
                                          .toString();
                                      setState(() => initSpd =
                                          controllerInit1.roundToDouble());
                                    },
                                    min: 80,
                                    max: 80000,
                                    divisions: 80000 - 80,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 250,
                                      child: Text("Resolution: $resolution2",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
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
                                      setState(() => resolution =
                                          newResolution.roundToDouble());
                                    },
                                    min: 1,
                                    max: 16,
                                    divisions: 3,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 250,
                                      child: Text("Load: $load%",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
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
                        ))),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text('Continuous'),
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
