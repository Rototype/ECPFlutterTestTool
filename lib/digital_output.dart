import 'package:flutter/material.dart';
import 'ws_manage.dart';
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
          body: Center(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.outputButtons.length,
                  itemBuilder: (_, int index) {
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: user.outputButtons[index].row,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: ElevatedButton(
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
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: ElevatedButton(
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
                  })));
    });
  }
}
