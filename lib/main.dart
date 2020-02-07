import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hwcontrollerCommand_page.dart';
import 'login_page.dart';
import 'mainCommand_page.dart';
import 'user_repository.dart';

void main() => runApp(MyApp());
TextEditingController controller = TextEditingController();

List<Color> color = [
  Colors.lightBlue[200]
];

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
      routes: {
        '/call': (_) => CallPage(),
        '/first': (_) => UserInfoPage()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {           
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage();
            case Status.CallPage:
              return CallPage();
            case Status.EndCallPage:
              return EndCallPage();

          }
        },
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    
    List<FlatButton> funct = [
      FlatButton(
        onPressed: () async {
          // await Future.delayed(Duration(seconds: 2));
          user.openCall();
        },    
        color: Colors.indigo[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[           
            Text('Main')
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          user.openEndCall();
          },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[       
                
            Text('HW Controller')
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(       
        actions: <Widget>[
          IconButton(           
            icon: Icon(Icons.arrow_back),
            tooltip: 'go Back', 
            onPressed: () {
             user.disconnect();  
            },
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(80, 100, 0, 0),
          itemCount: funct.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200,    
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),               
                    child: funct[index]
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(100, 0 , 0, 0),
                    child:Text('Prova descrizione bottoni')
                  ,)
                ], 
              )
            );
          },
        )
      ), 
    );   
  }
}
