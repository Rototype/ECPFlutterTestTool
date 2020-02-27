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
        body: 
          Container(           
            child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
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

  double acc22 = 0;

  double spd1 = 0;
  double spd3 = 0;

  double spd21 = 0;
  double spd22 = 0;


  double initSpd1 = 0;

  double steps1 = 0;
  double steps2 = 0;

 int currentIndex = 0;

 void _onItemTapped(int index) {
  setState(() {
    currentIndex = index;
  });
}
  @override
  Widget build(BuildContext context) {
        return Consumer<WebSocketClass>(builder: (_, user, __) {
        return Scaffold(
        appBar: AppBar(
          title: Text(' Stepper Motor ${user.index}'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentIndex == 0 ?
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 300,
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(
                        ' Continuous ',
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
                          child: Text('Motor Start',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),                        
                          onPressed: () {
                            user.send('CMD_SetStepperMotorSpeed@Main(${user.index-1},1,$spd1,$acc1,50)');
                          },
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
                                    child: Text('SPD: ${spd1.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                    child: Text('Acc: ${acc1.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                        'Init Speed: ${initSpd1.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                          child: Text('Motor Stop',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            user.send('CMD_SetStepperMotorSpeed@Main(${user.index-1},1,0,$acc2,50)');
                          },
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
                                    child: Text('Acc: ${acc2.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                          child: Text('Motor Speed Change',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                                user.send('CMD_SetStepperMotorSpeed@Main(${user.index-1},1,$spd3,$acc3,50)');
                          },
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
                                    child: Text('Spd: ${spd3.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                    child: Text('Acc: ${acc3.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
            ) : currentIndex == 1 ?
            Column(
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
                          child: Text('Motor Start infinite Acc',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            user.send('CMD_SetStepperMotorCountSteps@Main(${user.index-1},1,$spd21,$acc22,50,$steps2)');
                          },
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
                                    child: Text('SPD: ${spd21.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                        'Steps: ${steps1.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                          child: Text('Motor Start Acc variable',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            user.send('CMD_SetStepperMotorCountSteps@Main(${user.index-1},1,$spd22,$acc22,50,$steps2)');
                          },
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
                                    child: Text('Spd: ${spd22.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                    child: Text('Acc: ${acc22.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                Slider(
                                  value: acc22,
                                  onChanged: (newAcc21) {
                                    setState(() => acc22 = newAcc21);
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
                                    child: Text('Steps: ${steps2.round()}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
            ) :
            Container()
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
