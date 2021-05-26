import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'ws_manage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool ipConfig = false;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          if (!ipConfig) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              ipConfig = false;
            }
          }
        }));
    final user = Provider.of<WebSocketClass>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Rotosock"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Material(
                  elevation: 50.0,
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.red,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (!await user.wsconnect())
                          _key.currentState.showSnackBar(SnackBar(
                            content: Text("Something is wrong"),
                          ));
                      }
                    },
                    child: Text(
                      "Connect",
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () {
          ipConfig = true;
          Navigator.pushNamed(context, '/IpConfig');
        },
      ),
    );
  }
}

class IpConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (__, WebSocketClass user, _) {
      if (user.ipurl.text == "") {
        user.ipurl.text = "ws://127.0.0.1:5001";
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Ip Configuration'),
        ),
        body: Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Container(
                  width: 100,
                  child: Text(
                    'Full URL: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: user.ipurl,
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
