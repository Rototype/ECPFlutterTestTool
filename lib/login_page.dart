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
      appBar: AppBar(
        title: Text("Rototype WebSocket Console"),
      ),
      body: Form(
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
                    onPressed: () async { await user.wsconnect(); },
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
        tooltip: 'Settings',
        onPressed: () {
          ipConfig = true;
          Navigator.pushNamed(context, '/IpConfig');
        },
      ),
    );
  }
}

class IpConfig extends StatelessWidget {
  final TextEditingController _urlcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configuration'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                  Consumer(builder: (__, WebSocketClass user, _) {
                    _urlcontroller.text = user.ws_url;
                    return FocusScope(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus)
                            user.ws_url = _urlcontroller.text; // validate if we leave the page
                        },
                        child: TextFormField(
                          autofocus: true,
                          controller: _urlcontroller,
                          decoration: InputDecoration(
                            labelText: 'Websocket URL:',
                            hintText: 'ws://127.0.0.1:5001',
                          ),
                          onEditingComplete: () =>
                              user.ws_url = _urlcontroller.text,
                        ));
                  }),
                  Consumer(builder: (__, ThemeChangerClass user, _) {
                    return CheckboxListTile(
                      title: Text("Yes, My eyes are hurt by the light themes"),
                      value: user.isDarkMode,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (checked) => user.isDarkMode = checked,
                    );
                  }),
                ])));
  }
}
