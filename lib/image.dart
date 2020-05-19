import 'package:flutter/material.dart';
import 'package:provaProvider/ws_manage.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';


class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  String name = '';
  String error;
  Uint8List data;
  String message;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Imagine Processing'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.open_in_browser),
          onPressed: () {
          },
        ),
        body: Container(
          child: error != null ? 
                Text(error)
                : data != null ? 
                    Row(                     
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 500,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.red, width: 5)),
                                  child: Image.memory(data)),
                              FlatButton(
                                        color: Colors.indigo[50],
                                child: Text("Send Image",
                                style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                onPressed: () {
                                  try{
                                  user.send("CMD_InvertImage@Main[$message]");
                                  }catch(e){
                                    print(e);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                    user.image != null ? 
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),

                        child: Column(
                          children: <Widget>[
                            Container(
                                  width: 500,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.red, width: 5)),
                                  child: Image.memory(user.image)),
                          ],
                        ),
                      )
                      : Container()
                      ],
                    )
                    
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 5)),
                    ),
        ),
      );
    });
  }
}
