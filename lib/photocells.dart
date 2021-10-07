import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getPhotocellButton(int i, BigInt result) {
  return (TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          result & BigInt.from(pow(2, i)) != BigInt.from(0)
              ? Hero(
                  tag: 'hero $i',
                  child: const Icon(
                    Icons.lightbulb,
                    color: Colors.greenAccent,
                  ))
              : Hero(
                  tag: 'hero $i',
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.red,
                  )),
          Text('F ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/PhotocellPage',
          arguments: i);
    },
  ));
}

dynamic photocellButtons;

class Photocells extends StatefulWidget {
  const Photocells({Key key}) : super(key: key);

  @override
  State createState() => PhotocellsState();
}

class PhotocellsState extends State<Photocells> {
  WebSocketClass _wsc;

  @override
  void didChangeDependencies() {
    _wsc = Provider.of<WebSocketClass>(context, listen: false);
    _wsc.startSensorPolling();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _wsc.stopSensorPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      photocellButtons = List.generate(WebSocketClass.photocellStateSize,
          (i) => getPhotocellButton(i, _wsc.result));
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Photocells'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: photocellButtons,
              )));
    });
  }
}

class PhotocellPage extends StatefulWidget {
  const PhotocellPage({Key key}) : super(key: key);

  @override
  _PhotocellPageState createState() => _PhotocellPageState();
}

class _PhotocellPageState extends State<PhotocellPage> {
  double value = 500;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' Photocell ${index + 1}'),
          ),
          body: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  user.result & BigInt.from(pow(2, index)) != BigInt.from(0)
                      ? Hero(
                          tag: 'hero $index',
                          child: const Icon(
                            Icons.lightbulb,
                            color: Colors.greenAccent,
                            size: 100,
                          ))
                      : Hero(
                          tag: 'hero $index',
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.red,
                            size: 100,
                          )),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('$index');
                      user.send('CMD_SetAnalogOutput@Main($index,$value)');
                    },
                    child: const Text('Set Diode PWM'),
                  ),
                  const SizedBox(height: 10),
                  Text('Value: ${value.round()}‰'),
                  Slider(
                    label: '${value.round()}‰',
                    value: value,
                    onChanged: (newValue) {
                      setState(() => value = newValue);
                    },
                    min: 0,
                    max: 1000,
                    divisions: 100,
                  ),
                ],
              ),
            ],
          ));
    });
  }
}
