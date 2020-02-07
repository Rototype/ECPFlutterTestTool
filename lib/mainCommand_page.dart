import 'main.dart';
import 'package:flutter/material.dart';
import 'user_repository.dart';
import 'package:provider/provider.dart';

class CallPage extends StatelessWidget {
   
  //127:8080
  //TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(builder: (_, user, __) {
    return Scaffold(
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

                  padding: EdgeInsets.fromLTRB(60, 30, 60, 0),
                  child:SizedBox(
                    
                    height: 200,
                    width: 200,
                    child:ListView.builder(
                      
                      shrinkWrap: true,
                      itemCount: user.messageString.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Text(                      
                          user.messageString[index],
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
                  onPressed: () {
                    user.clear();
                  }
                ),
                ]
              ),
              Row(children: <Widget>[
                      RaisedButton(
                    
                    child: Text('Restart'),
                    onPressed: () {
                      user.send('CMD_Restart@Main#');
                    },
                  ),
                  RaisedButton(

                    child: Text('Status'),
                    onPressed: () {
                      Future.delayed(const Duration(milliseconds: 1000), () {
                      user.send('CMD_Status@Main#');
                      });
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
