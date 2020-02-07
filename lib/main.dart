import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'ws.dart';

void main() => runApp(MyApp());
TextEditingController controller = TextEditingController();
String message;
List<String> list;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
      routes: {'/second': (_) => SecondPage(), '/first': (_) => UserInfoPage()},
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Ws.instance(),
      child: Consumer(
        builder: (context, Ws user, _) {
          switch (user.status) {
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage();
          }
        },
      ),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    list = new List<String>();
    final user = Provider.of<Ws>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Prova WebSocket'),
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(200, 100, 200, 0),
          child: Column(
            children: <Widget>[
              Form(
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Insert Message',
                  ),
                ),
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.send),
                    Text('Send Message'),
                  ],
                ),
                onPressed: () {
                  user.send(controller.text);
                },
              ),
              SizedBox(
                height: 350, // constrain height
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: user.list.length,
                  itemBuilder: (context, i) {
                    return Text(user.list[i]);
                  },
                )
              )
            ],
          ),
        )
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second page')),
    );
  }
}
