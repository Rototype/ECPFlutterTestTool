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
        title: Text('DCMotor'),       
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
class DCMotorPage extends StatelessWidget {
  const DCMotorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Consumer<WebSocketClass>(
      builder: (_, user, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(' DCMotor ${user.index}'),
          ),
          body: Container(
            child: Column(children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDCMotor@Main(${user.index-1},on)');                
                  },
                  child: Text('Set Motor'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDCMotorPWM@Main(${user.index-1},1,50)');                
                  },
                  child: Text('Set Motor PWM'),
                )
            ],),
          ),
        );
      }
    );
  }
}
