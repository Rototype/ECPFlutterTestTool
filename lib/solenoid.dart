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
            child:  Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  width: 200,
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

class SolenoidPage extends StatelessWidget {
  const SolenoidPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(
      builder: (_, user, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(' Solenoid ${user.index}'),
          ),
          body: Container(
            child: Column(children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDCSolenoid@Main(${user.index-1},on)');                
                  },
                  child: Text('Set Motor'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDCSolenoidPWM@Main(${user.index-1}, on, 100, 100)');                
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
