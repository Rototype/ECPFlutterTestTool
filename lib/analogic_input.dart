import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class AnalogicInputs extends StatelessWidget {
   
  //TextEditingController controller = new TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Command @HwController'),
        ),
        body:Container(           
            child:  Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.inputButtons.length,
                    itemBuilder: (_, int index) {
                      return user.inputButtons[index].button;
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

class AnalogicInputPage extends StatelessWidget {
  const AnalogicInputPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(
      builder: (_, user, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(' Analogic Input ${user.index}'),
          ),
          body: Container(
            child: Column(children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_ReadAnalogInput@Main(${user.index-1})');                
                  },
                  child: Text('Read'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetAnalogOutput@Main(${user.index-1}, 300');                
                  },
                  child: Text('Set'),
                )
            ],)
          ),
        );
      }
    );
  }
}