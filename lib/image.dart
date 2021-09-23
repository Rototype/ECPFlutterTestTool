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

  Future<void> pickFile() async {
    if (UniversalPlatform.isLinux || UniversalPlatform.isWindows) {
      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'bmp']);
      final pickedFile = await openFile(acceptedTypeGroups: [typeGroup]);
      if (pickedFile != null) {
        data = await pickedFile.readAsBytes();
        message = pickedFile.path;
      } else {
        error = 'No image selected.';
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
  const ImagePickerPage({Key key}) : super(key: key);

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
          title: const Text('Imagine Processing '),
          actions: <Widget>[
            ElevatedButton.icon(
                label: const Text('Send'),
                icon: const Icon(Icons.send),
                onPressed: imageData.data == null
                    ? null
                    : () {
                        try {
                          user.send("CMD_InvertImage@Main[${base64.encode(imageData.data)}]");
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }),
            ElevatedButton.icon(
                label: const Text('Delete'),
                icon: const Icon(Icons.delete_forever),
                onPressed: user.image == null
                    ? null
                    : () {
                        user.image = null;
                        if (mounted) setState(() {});
                      }),
            const SizedBox(width: 10), // icon + text is touching the border
          ],
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Open image',
            child: const Icon(Icons.open_in_browser),
            onPressed: () async {
              await imageData.pickFile();
              if (imageData.data != null) if (mounted) setState(() {});
            }),
        body: Center(
          child: imageData.data != null
              ? ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        children: <Widget>[
                          Container(width: screen.size.width, decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 5)), child: Image.memory(imageData.data)),
                          ElevatedButton(
                            child: const Text("Send Image", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              try {
                                user.send("CMD_InvertImage@Main[${base64.encode(imageData.data)}]");
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    user.image != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
                            child: Column(
                              children: [
                                Container(width: screen.size.width, decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 5)), child: Image.memory(user.image)),
                                ElevatedButton(
                                  child: const Text("Delete Image", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    try {
                                      user.image = null;
                                    } catch (e) {
                                      debugPrint(e.toString());
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
                  decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 5)),
                ),
        ),
      );
    });
  }
}
