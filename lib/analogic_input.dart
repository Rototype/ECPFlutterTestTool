import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class AnalogicInput extends StatelessWidget {
   
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
