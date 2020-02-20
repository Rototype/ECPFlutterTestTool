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

class MotorStPage extends StatelessWidget {
  const MotorStPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(
      builder: (_, user, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(' STMotor ${user.index}'),
          ),
          body: Container(
            child: Column(children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetStepperMotorSpeed@Main(${user.index-1},on,20,5,100)');                
                  },
                  child: Text('Set Speed'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetStepperMotorCountSteps@Main(1,on,20,5,100,500)');                
                  },
                  child: Text('Set Count Steps'),
                )
            ],)
          ),
        );
      }
    );
  }
}