import 'package:FlutterFirebase2/main.dart';
import 'package:flutter/material.dart';
import 'user_repository.dart';
import 'package:provider/provider.dart';

class CallPage extends StatelessWidget {
   
  
  //TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Consumer<UserRepository>(builder: (_, user, __) {
          return Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Premere'),
                onPressed: () {
                  user.send('true@call');
                },
              ),
              RaisedButton(
                child: Text('Premere 2 '),
                onPressed: () {
                  user.send('false@call');
                },
              ),
              RaisedButton(
                child: Text('Indietro'),
                onPressed: () {
                  user.openHome();
                },
              ),
              Row(
                
                children: <Widget>[
                  Text('Message received: '),
                  Text(
                    user.messageString
                  )
                ],
              )
            ]
          );
        }  
      )
    );
  }
}
