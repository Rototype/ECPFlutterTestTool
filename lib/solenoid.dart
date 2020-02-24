import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class Solenoid extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Solenoid'),       
      ),
        body: 
           Container(           
            child:  Row(
              children: <Widget>[
                SizedBox(
                  width: 500,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.solenoidButtons.length,
                    itemBuilder: (_, int index) {
                      return user.solenoidButtons[index].button;
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

class SolenoidPage extends StatefulWidget {

  @override
  _SolenoidPageState createState() => _SolenoidPageState();
}

class _SolenoidPageState extends State<SolenoidPage> {
  double pwm = 0;
  double inittime = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Solenoid ${user.index}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: RaisedButton(
                  onPressed: () {
                    // DO SOMETHING                    
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
                child: RaisedButton(
                  onPressed: () {
                    // DO SOMETHING
                  },
                  child: Text('Set Solenoid OFF',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: RaisedButton(                 
                  onPressed: () {
                    // DO SOMETHING
                  },
                  child: Text(
                      '     Set Solenoid\nPWM: ${pwm.round()}  InitTime: ${inittime.round()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Slider(
                        value: pwm,
                        onChanged: (newRating) {
                          setState(() => pwm = newRating);
                        },
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: "PWM: ${pwm.round()}",
                      ),
                      Slider(
                        value: inittime,
                        onChanged: (newRating) {
                          setState(() => inittime = newRating);
                        },
                        min: 0,
                        max: 2000,
                        divisions: 2000,
                        label: "InitTime: ${inittime.round()}",
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
    );
    }
    );
  }
}
