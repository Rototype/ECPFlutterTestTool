import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class AnalogicInputs extends StatelessWidget {
  //TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Command @HwController'),
          ),
          body: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
            SizedBox(
                width: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.inputButtons.length,
                    itemBuilder: (_, int index) {
                      return user.inputButtons[index].button;
                    }))
          ])));
    });
  }
}

class AnalogicInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analog Input ${user.index}'),
        ),
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
              children: <Widget>[
                user.inputList.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Readed Value: ${user.inputList[user.index-1]}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                )
                : Text(''),
              ],
              ),
            ],
          )),
      );
    });
  }
}
