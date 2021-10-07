import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getOutputButton(int i, bool active) {
  return TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          Hero(
              tag: 'hero $i',
              child: active
                  ? const Icon(Icons.check_box, color: Colors.red)
                  : const Icon(Icons.check_box_outline_blank,
                      color: Colors.green)),
          Text('Out ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/OutputPage',
          arguments: i);
    },
  );
}

dynamic outputButtons;

class Output extends StatelessWidget {
  const Output({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wsc = Provider.of<WebSocketClass>(context, listen: false);
    outputButtons = List.generate(WebSocketClass.outputStateSize,
        (i) => getOutputButton(i, wsc.getOutputState(i)));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Digital output'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: outputButtons,
              )));
    });
  }
}

class OutputPage extends StatelessWidget {
  const OutputPage({Key key}) : super(key: key);

  final double pwm = 0;
  final bool isChecked = false;
  final double value = 20000;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' Output ${index + 1}'),
          ),
          body: Row(children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                    tag: 'hero $index',
                    child: user.getOutputState(index)
                        ? const Icon(Icons.check_box,
                            color: Colors.red, size: 100)
                        : const Icon(Icons.check_box_outline_blank,
                            color: Colors.green, size: 100)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text('Out '),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          child: const Text(
                            "ON",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            user.send('CMD_SetDigitalOutput@Main($index,1)');
                            user.setOutputState(index, true);
                            outputButtons[index] = getOutputButton(
                                index, user.getOutputState(index));
                          }),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () {
                            user.send('CMD_SetDigitalOutput@Main($index,0)');
                            user.setOutputState(index, false);
                            outputButtons[index] = getOutputButton(
                                index, user.getOutputState(index));
                          },
                          child: const Text(
                            "OFF",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                )
              ],
            )
          ]));
    });
  }
}
