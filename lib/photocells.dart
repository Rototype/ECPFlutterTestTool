import 'dart:math';

import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class Photocells extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Photocells'),
          ),
          body: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                    width: 300,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: user.photocellButtons.length,
                        itemBuilder: (_, int index) {
                          return user.photocellButtons[index].button;
                        }))
              ])));
    });
  }
}

class PhotocellPage extends StatefulWidget {
  @override
  _PhotocellPageState createState() => _PhotocellPageState();
}

class _PhotocellPageState extends State<PhotocellPage> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' Photocell ${user.index}'),
          ),
          body: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              user.index != -1
                  ? Column(
                      children: <Widget>[
                        user.result & BigInt.from(pow(2, user.index-1)) == BigInt.from(0)
                            ? Hero(
                                tag: 'hero ${user.index - 1}',
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.greenAccent,
                                  size: 200,
                                )
                              )
                            : Hero(
                                tag: 'hero ${user.index - 1}',
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.red,
                                  size: 200,
                                )),
                        Column(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                user.send(
                                    'CMD_SetAnalogOutput@Main(${user.index - 1},off)');
                              },
                              child: Text('Set Diod PWM',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: <Widget>[
                                Text('Value: $value',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Slider(
                                  value: value,
                                  onChanged: (newValue) {
                                    setState(() => value = newValue);
                                  },
                                  label: '${value.round()}',
                                  min: 0,
                                  max: 4096,
                                  divisions: 64,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  : Column()
            ],
          )));
    });
  }
}
