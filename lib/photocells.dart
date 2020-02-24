import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class Photocells extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Photocells'),       
      ),
        body: 
          Container(           
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 500,
                  child: ListView.builder(                  
                    shrinkWrap: true,
                    itemCount: user.photocellButtons.length,
                    itemBuilder: (_, int index) {                     
                      return user.photocellButtons[index].button;
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
class PhotocellPage extends StatelessWidget {
  const PhotocellPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(
      builder: (_, user, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(' Photocell ${user.photocellButtons[user.index-1].id}'),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_ReadDigitalInput@Main#');                
                  },
                  child: Text('Read'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDigitalOutput@Main(${user.index},off)');                
                  },
                  child: Text('Set OFF'),
                ),
                RaisedButton(
                  onPressed: (){
                    user.send('CMD_SetDigitalOutput@Main(${user.index},on)');                
                  },
                  child: Text('Set ON'),
                )
              ],
            )
          ),
        );
      }
    );
  }
}
