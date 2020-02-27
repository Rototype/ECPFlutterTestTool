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
                  width: 300,
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
            title: Text(' Photocell ${user.index}'),
          ),
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                user.index != -1 ?
                Column(
                  children: <Widget>[
                    (user.result & BigInt.from(1<<user.index-1))==BigInt.from(0) ?
                    Hero(
                        tag: 'hero ${user.index-1}',
                        child: Icon(
                          Icons.lightbulb_outline, color: Colors.greenAccent,
                          size: 200,
                      )                   
                    ) :
                    Hero(                  
                        tag: 'hero ${user.index-1}',
                        child: Icon(
                          Icons.lightbulb_outline, color: Colors.red,
                          size: 200,
                      )                   
                    ),
                    RaisedButton(
                      onPressed: (){
                        user.send('CMD_ReadDigitalInput@Main#');                
                      },
                      child: Text('Read'),
                    ),
                    RaisedButton(
                      onPressed: (){
                        user.send('CMD_SetDigitalOutput@Main(${user.index-1},off)');                
                      },
                      child: Text('Set OFF'),
                    ),
                    RaisedButton(
                      onPressed: (){
                        user.send('CMD_SetDigitalOutput@Main(${user.index-1},on)');                
                      },
                      child: Text('Set ON'),
                    )
                  ],
                ) : 
                Column()
              ],
            )
          ) 
        );
      }
    );
  }
}
