import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class CallPage extends StatelessWidget {
   
  //127:8080
  //TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Command @Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back), 
            onPressed: (){
              user.openHome();
            }
          )         
        ],
      ),
        body: 
           Container(           
            child:  Column(
              children: <Widget>[  
                Row(
                  children: <Widget>[               
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                    child:SizedBox(
                      height: 300,
                      width: 250,
                      child:ListView.builder(                        
                        shrinkWrap: true,
                        itemCount: user.messageStringMain.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Text(                                                
                            user.messageStringMain[index],
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
                      user.clearMain();
                    }
                  ),
                ]
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                buttonPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),                
                children: <Widget>[
                  FloatingActionButton.extended(                
                    label: Text('Restart'),
                    onPressed: () {
                      user.send('CMD_Restart@Main#');
                    },
                  ),
                  FloatingActionButton.extended(
                    label: Text('Status'),
                    onPressed: () {
                      user.send('CMD_Status@Main#');
                      }
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
