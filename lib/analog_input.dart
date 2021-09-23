import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getInputButton(int i, int value) {
  return TextButton(
      onPressed: () {
        Navigator.pushNamed(_scaffoldKey.currentContext, '/inputAnalogPage', arguments: i);
      },
      child: SizedBox(
          width: 80,
          child: Column(children: <Widget>[
            Hero(
                tag: 'hero $i',
                child: const Icon(
                  Icons.format_line_spacing,
                  color: Colors.greenAccent,
                )),
            Text('Input ${i + 1}'),
            Text('Value: $value'),
          ])));
}

dynamic inputButtons;

class AnalogicInputs extends StatefulWidget {
  const AnalogicInputs({Key key}) : super(key: key);

  @override
  State createState() => AnalogicInputsState();
}

class AnalogicInputsState extends State<AnalogicInputs> {
  WebSocketClass _wsc;

  @override
  void didChangeDependencies() {
    _wsc = Provider.of<WebSocketClass>(context, listen: false);
    _wsc.startInputPolling();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _wsc.stopInputPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      inputButtons = List.generate(WebSocketClass.inputStateSize, (i) => getInputButton(i, _wsc.inputState[i]));
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Analog Inputs'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: inputButtons,
              )));
    });
  }
}

class AnalogInputPage extends StatelessWidget {
  const AnalogInputPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analog Input ${index + 1}'),
        ),
        body: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                    tag: 'hero $index',
                    child: const Icon(
                      Icons.format_line_spacing,
                      color: Colors.greenAccent,
                      size: 100,
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Read Value: ${user.inputState[index]}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
