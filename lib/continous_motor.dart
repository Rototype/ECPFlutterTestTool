import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class DCMotor extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('DC Motor'),       
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
                    itemCount: user.dcMotorButtons.length,
                    itemBuilder: (_, int index) {
                      return user.dcMotorButtons[index].button;
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


class DCMotorPage extends StatefulWidget {
  DCMotorPage({Key key}) : super(key: key);

  @override
  _DCMotorPageState createState() => _DCMotorPageState();
}

class _DCMotorPageState extends State<DCMotorPage> {
  bool isChecked = false;
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' DC Motor ${user.index}'),
        ),
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(                
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 150,
                          child: RaisedButton(
                            child: Text(
                              'Off',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () {
                              user.send('CMD_SetDCMotor@Main(${user.index-1},0)');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              user.send('CMD_SetDCMotor@Main(${user.index-1},brake)');
                            },
                            child: Text('Brake',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 150,
                          child: RaisedButton(
                            child: Text('Run Clockwise',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () {
                              if(!isChecked){
                                user.send('CMD_SetDCMotor@Main(${user.index-1},1)');
                              }
                              else{
                                user.send('CMD_SetDCMotorPWM@Main(${user.index-1},1,$value)');
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              if(!isChecked){
                                user.send('CMD_SetDCMotor@Main(${user.index-1},-1)');
                              }
                              else{
                                user.send('CMD_SetDCMotorPWM@Main(${user.index-1},-1,$value)');
                              }
                            },
                            child: Text('Run CClockwise',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Enable PWM: ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool newValue) {
                          setState(() {
                            isChecked = newValue;
                          });
                        },
                      ),
                      isChecked
                          ? Row(
                            children: <Widget>[
                              Slider(
                                value: value,
                                onChanged: (newValue) {
                                  setState(() {
                                    value = newValue;
                                   });
                                },
                                min: 0,
                                max: 100,
                                divisions: 100,
                              ),
                              Text('PWM: ${value.round()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ],
                          )
                          : Slider(
                              value: value,
                              onChanged: null,
                              min: 0,
                              max: 100,
                              divisions: 100,
                            )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
    });
  }
}
