import 'package:flutter/material.dart';
import 'package:provaProvider/ws_manage.dart';
import 'package:provider/provider.dart';

class Output extends StatefulWidget {
  @override
  _OutputState createState() => _OutputState();
}

class _OutputState extends State<Output> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Digital Output'),
          ),
          body: Container(
              child: Row(children: <Widget>[
            SizedBox(
                width: 450,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.outputButtons.length,
                    itemBuilder: (_, int index) {
                      return Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,15,0,0),
                            child: user.outputButtons[index].row,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,15,0,0),
                            child: RaisedButton(
                                child: Text(
                                  "ON",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  user.send(
                                      'CMD_SetDigitalOutput@Main($index,1)');
                                  user.outputList[index] = 1;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,15,0,0),
                            child: RaisedButton(
                                onPressed: () {
                                  user.send(
                                      'CMD_SetDigitalOutput@Main($index,0)');
                                  user.outputList[index] = 0;
                                },
                                child: Text(
                                  "OFF",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      );
                    }))
          ])));
    });
  }
}
