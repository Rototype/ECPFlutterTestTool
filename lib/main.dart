import 'package:flutter/material.dart';
import 'package:provaProvider/page3.dart';
import 'package:provaProvider/page2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/page2': (_) => Page2(),        
        '/page3': (_) => Page3(),       
      }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page')
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Premere -> Pag2'),
            onPressed: (){
              Navigator.pushNamed(context, '/page2');
            }
          ),
          RaisedButton(
            child: Text('Premere -> Pag3'),
            onPressed: (){
              Navigator.pushNamed(context, '/page3');
            }
          )
        ],
      )
    );
  }
}
