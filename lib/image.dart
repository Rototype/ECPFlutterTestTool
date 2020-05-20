import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provaProvider/ws_manage.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    data = image.readAsBytesSync();

    setState(() {
      _image = image;
    });
  }
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
            getImage();
          },
        ),
        body: Center(
          child: _image != null ? 
                    ListView( 
                      scrollDirection: Axis.horizontal,                    
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 500,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.red, width: 5)),
                                  child: Image.file(_image)),
                              FlatButton(
                                        color: Colors.indigo[50],
                                child: Text("Send Image",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold)),
                                onPressed: () {
                                  try{
                                  user.send("CMD_InvertImage@Main[${base64.encode(data)}]");
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
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: 
                          Column(
                            children: [
                              Container(
                                  width: 500,
                                  height: 300,
                                    decoration: BoxDecoration(
                                      border:
                                        Border.all(color: Colors.red, width: 5)
                                    ),
                                    child: Image.memory(user.image)
                                  ),
                                  FlatButton(
                                        color: Colors.indigo[50],
                                child: Text("Delete Image",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold)),
                                onPressed: () {
                                  try{
                                    user.image = null;
                                  }catch(e){ 
                                    print(e);
                                  }
                                },
                              )
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
