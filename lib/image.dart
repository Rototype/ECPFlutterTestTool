import 'dart:convert';
import 'dart:typed_data';
import 'package:universal_platform/universal_platform.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class ImageData {
  ImageData();

  final picker = ImagePicker();

  Uint8List data;
  String message;
  String error;

  Future<void> Pick() async {
    if (UniversalPlatform.isLinux || UniversalPlatform.isWindows) {
      final typeGroup =
          XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'bmp']);
      final pickedFile = await openFile(acceptedTypeGroups: [typeGroup]);
      if (pickedFile != null) {
        data = await pickedFile.readAsBytes();
        message = pickedFile.path;
      } else {
        error = 'No image selected.';
      }
    } else {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        data = await pickedFile.readAsBytes();
        message = pickedFile.path;
      } else {
        error = 'No image selected.';
      }
    }
  }
}


class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImageData imageData = ImageData();
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    return Consumer<WebSocketClass>(builder: (_, user, __) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Imagine Processing '),
          actions: <Widget>[
            TextButton.icon(
              label: Text('Send'),
              icon: Icon(Icons.send),

              onPressed: imageData.data == null? null : () {
                try {
                  user.send("CMD_InvertImage@Main[${base64.encode(imageData.data)}]");
                } catch (e) {
                  print(e);
                }
              }
            ),
            TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete_forever),

              onPressed: user.image == null? null : () {
                user.image = null;
                if (this.mounted) setState(() {});
              }
            ),
            SizedBox(width: 10),    // icon + text is touching the border

          ],
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Open image',
            child: Icon(Icons.open_in_browser),
            onPressed: () async {
              await imageData.Pick();
              if (imageData.data != null) if (this.mounted) setState(() {});
            }),
        body: Center(
          child: imageData.data != null
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
                              child: Image.memory(imageData.data)),
                          TextButton(
                            child: Text("Send Image",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              try {
                                user.send(
                                    "CMD_InvertImage@Main[${base64.encode(imageData.data)}]");
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
