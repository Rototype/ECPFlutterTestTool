import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
                        width: 300,
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
                user.percent == 0.00 || user.percent == 1
                  ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(user.finished)
                  )
                  : 
                LinearPercentIndicator(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  width: 350.0,
                  lineHeight: 8.0,
                  percent: user.percent,              
                  progressColor: Colors.red,
                ),                 
              ]
            ) 
          )
        );
      }
    );
  }
}
