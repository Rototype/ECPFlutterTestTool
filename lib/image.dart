import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

import 'websocket.dart';

class ImageData {
  Uint8List data;
  String message;
  String error;

  ImageData(String message, Uint8List data, String error) {
    this.data = data;
    this.message = message;
    this.error = error;
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Uint8List data;
  String error;
  ImageData imageData;
  String message;
  String name = '';
  SocketFinder wSocket;

  var _image;

  @override
  Widget build(BuildContext context) {
    wSocket = new SocketFinder();
    var screen = MediaQuery.of(context);
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Imagine Processing '),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Open image',
          child: Icon(Icons.open_in_browser),
          onPressed: () async {
            if (wSocket.isWeb()) {
              await wSocket.pickImage();
              if (wSocket.getImage() != null) {
                setState(() {
                  data = wSocket.getImage();
                });
              }
            } else {
              await wSocket.pickImage();
              if (wSocket.getImage() != null) {
                setState(() async {
                  data = await wSocket.getImage();
                });
              }
            }
          },
        ),
        body: Center(
          child: _image != null || data != null
              ? ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: screen.size.width,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 5)),
                              child: Image.memory(data)),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.indigo[50],
                            ),
                            child: Text("Send Image",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              try {
                                user.send(
                                    "CMD_InvertImage@Main[${base64.encode(data)}]");
                              } catch (e) {
                                print(e);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    user.image != null
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(10, 50, 10, 30),
                            child: Column(
                              children: [
                                Container(
                                    width: screen.size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.red, width: 5)),
                                    child: Image.memory(user.image)),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.indigo[50],
                                  ),
                                  child: Text("Delete Image",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    try {
                                      user.image = null;
                                    } catch (e) {
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
