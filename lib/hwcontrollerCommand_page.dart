import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class EndCallPage extends StatelessWidget {
   
  //TextEditingController controller = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Command @HwController'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back), 
              onPressed: (){
                user.openHome();
              }
            )
          ],
        ),
        body:Container(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[ 
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child:SizedBox(                 
                        height: 320,
                        width: 200,
                        child:ListView.builder(
                          
                          shrinkWrap: true,
                          itemCount: user.messageStringHWcontroller.length,
                          itemBuilder: (_, int index) {
                            return Text(                      
                              user.messageStringHWcontroller[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,                        
                              ),
                            );
                          }
                        )
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.clear_all),
                      tooltip: 'Clear List',
                      onPressed: () {
                        user.clearHW();
                      }
                    ),
                  ]
                ),
                ButtonBar(
                  buttonPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FloatingActionButton.extended(     
                      label: Text('Status'),
                      onPressed: () {
                        user.send('CMD_Status@HWController#');
                      },
                    ),
                    FloatingActionButton.extended(
                      label: Text('Update Firmware'),
                      onPressed: () {
                        user.send('CMD_UpdateFirmware@HWController#');                   
                      },
                    ),
                  ],
                ), 
              ]
            ) 
          )
        );
      }
    );
  }
}
