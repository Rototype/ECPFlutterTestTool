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
        title: Text('MotorST'),       
      ),
        body: 
          Container(           
            child:  Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.stepperMotorButtons.length,
                    itemBuilder: (_, int index) {
                      return user.stepperMotorButtons[index].button;
                    }
                  )
                )
              ]
            )    
          )
        );
      }
    );
  }
}




class MotorStPage extends StatefulWidget {
  MotorStPage({Key key}) : super(key: key);

  @override
  _MotorStPageState createState() => _MotorStPageState();
}

class _MotorStPageState extends State<MotorStPage> {
  double acc1 = 0;
  double acc2 = 0;
  double acc3 = 0;

  double acc21 = 0;

  double spd1 = 0;
  double spd3 = 0;

  double spd21 = 0;
  double spd22 = 0;


  double initSpd1 = 0;

  double steps1 = 0;
  double steps2 = 0;

  @override
  Widget build(BuildContext context) {
        return Consumer<WebSocketClass>(builder: (_, user, __) {
        return Scaffold(
        appBar: AppBar(
          title: Text(' Solenoid ${user.index}'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Colors.black),
              left: BorderSide(width: 1.0, color: Colors.black),
              right: BorderSide(width: 1.0, color: Colors.black),
              bottom: BorderSide(width: 1.0, color: Colors.black),
            ),
          ),
          height: 500,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.black),
                    left: BorderSide(width: 1.0, color: Colors.black),
                    right: BorderSide(width: 1.0, color: Colors.black),
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 300,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            ' Continous ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            child: RaisedButton(
                              child: Text('Motor Start'),
                              onPressed: () {},
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('SPD: ${spd1.round()}')),
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Acc: ${acc1.round()}')),
                                    Slider(
                                      value: acc1,
                                      onChanged: (newAcc1) {
                                        setState(() => acc1 = newAcc1);
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
                                        width: 100,
                                        child: Text(
                                            'Init Speed: ${initSpd1.round()}')),
                                    Slider(
                                      value: initSpd1,
                                      onChanged: (newInitSpd) {
                                        setState(() => initSpd1 = newInitSpd);
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
                              child: Text('Motor Stop'),
                              onPressed: () {},
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Acc: ${acc2.round()}')),
                                    Slider(
                                      value: acc2,
                                      onChanged: (newAcc2) {
                                        setState(() => acc2 = newAcc2);
                                      },
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
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
                              child: Text('Motor Speed Change'),
                              onPressed: () {},
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Spd: ${spd3.round()}')),
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Acc: ${acc3.round()}')),
                                    Slider(
                                      value: acc3,
                                      onChanged: (newAcc3) {
                                        setState(() => acc3 = newAcc3);
                                      },
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.black),
                    left: BorderSide(width: 1.0, color: Colors.black),
                    right: BorderSide(width: 1.0, color: Colors.black),
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          
                          height: 40,
                          width: 300,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            ' Move with Steps',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white
                            ),
                          ),
                        )
                    ],),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            child: RaisedButton(
                              child: Text('Motor Start infinite Acc'),
                              onPressed: () {},
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('SPD: ${spd21.round()}')),
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
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text(
                                            'Steps: ${steps1.round()}')),
                                    Slider(
                                      value: steps1,
                                      onChanged: (newsteps1) {
                                        setState(() => steps1 = newsteps1);
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
                              child: Text('Motor Start Acc variable'),
                              onPressed: () {},
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Spd: ${spd22.round()}')),
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
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 100,
                                        child: Text('Acc: ${acc21.round()}')),
                                    Slider(
                                      value: acc21,
                                      onChanged: (newAcc21) {
                                        setState(() => acc21 = newAcc21);
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
                                        width: 100,
                                        child: Text('Steps: ${steps2.round()}')),
                                    Slider(
                                      value: steps2,
                                      onChanged: (newSteps2) {
                                        setState(() => steps2 = newSteps2);
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
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
