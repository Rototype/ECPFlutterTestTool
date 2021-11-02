import 'dart:convert';
import 'dart:io' as dartio;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotosocket/ws_manage.dart';
import 'package:universal_platform/universal_platform.dart';

class FirmwareUpdate extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  final bool value = false;

  FirmwareUpdate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
 return Scaffold(
        appBar: AppBar(
          title: const Text('Firmware Update'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            ElevatedButton(
              child: const Text('Update Hardware Controller'),
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles( 
                  type: FileType.custom,
                  allowedExtensions: ['bin'],
                );
                if (result != null) {
                  Uint8List data;
                  if (UniversalPlatform.isWeb) {
                    data = result.files.first.bytes;
                  } else {
                    final file = dartio.File(result.files.single.path);
                    data = await file.readAsBytes();
                  }
                  user.send("CMD_UpdateFirmware@HWController[${base64.encode(data)}]");
                } else {
                  // User canceled the picker
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Restart Hardware Controller'),
              onPressed: () {
                user.send('CMD_Restart@HWController#');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Update FPGA'),
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles( 
                  type: FileType.custom,
                  allowedExtensions: ['bin'],
                );
                if (result != null) {
                  Uint8List data;
                  if (UniversalPlatform.isWeb) {
                    data = result.files.first.bytes;
                  } else {
                    final file = dartio.File(result.files.single.path);
                    data = await file.readAsBytes();
                  }
                  user.send("CMD_UpdateFirmware@FPGA[${base64.encode(data)}]");
                } else {
                  // User canceled the picker
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Restart FPGA'),
              onPressed: () {
                user.send('CMD_Restart@FPGA#');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Update WebSocket service'),
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles( 
                  type: FileType.custom,
                  allowedExtensions: ['bin'],
                );
                if (result != null) {
                  Uint8List data;
                  if (UniversalPlatform.isWeb) {
                    data = result.files.first.bytes;
                  } else {
                    final file = dartio.File(result.files.single.path);
                    data = await file.readAsBytes();
                  }
                  user.send("CMD_UpdateWebSocketFirmware@Main[${base64.encode(data)}]");
                } else {
                  // User canceled the picker
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Reset Board'),
              onPressed: () {
                showConfirmDialog(
                  context, 
                  () => { 
                    user.send('CMD_Restart@Main#'),

                    user.disconnect("Resetting board...")
                  },
                  'This will disconnect the board, do you want to go on anyway?'
                );

              },
            ),
          ],
        ),
      );     });
  }
}


Future<bool> showConfirmDialog(
  BuildContext context, 
  Function confirmCallback,
  String message
) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Warning'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop();
              confirmCallback();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

