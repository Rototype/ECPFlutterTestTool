import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotosocket/theme_changer.dart';

import 'ws_manage.dart';

class ReconnectPage extends StatefulWidget {
  const ReconnectPage({Key key}) : super(key: key);

  @override
  _ReconnectPageState createState() => _ReconnectPageState();
}

class _ReconnectPageState extends State<ReconnectPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WebSocketClass>(context);
    final themeChanger = Provider.of<ThemeChangerClass>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Rototype Websocket Console ${themeChanger.version}"),
      ),
      body: ListView(padding: const EdgeInsets.all(50), children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await user.wsconnect();
          },
          child: const Text('Connect'),
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () {
          Navigator.pushNamed(context, '/IpConfig');
        },
      ),
    );
  }
}

class IpConfig extends StatelessWidget {
  final TextEditingController _urlcontroller = TextEditingController();

  IpConfig({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuration'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Consumer(builder: (__, WebSocketClass user, _) {
                _urlcontroller.text = user.wsUrl;
                return FocusScope(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        user.wsUrl = _urlcontroller.text;
                      } // validate if we leave the page
                    },
                    child: TextFormField(
                      autofocus: true,
                      controller: _urlcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Websocket URL:',
                        hintText: 'ws://localhost:5001',
                      ),
                      onEditingComplete: () => user.wsUrl = _urlcontroller.text,
                    ));
              }),
              Consumer(builder: (__, ThemeChangerClass user, _) {
                return CheckboxListTile(
                  title: const Text('Yes, My eyes are hurt by the light themes'),
                  value: user.isDarkMode,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (checked) => user.isDarkMode = checked,
                );
              }),
            ])));
  }
}
