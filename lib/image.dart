import 'dart:io' as dartio;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter/material.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';


class ImageData {
  ImageData();


  Uint8List data;
  String message;
  String error;

  Future<void> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles( 
      type: FileType.custom,
      allowedExtensions: ['bmp'],
    );
    if (result != null) {
      final file = dartio.File(result.files.single.path);
      data = await file.readAsBytes();
      message = result.files.single.path;
    } else {
      // User canceled the picker
      error = 'No image selected.';
    }
  }
}

class ImageBmp {
  final String assetpath;
  final Uint8List bmpblob;
  ImageBmp(this.assetpath, this.bmpblob);
}

Future<List<ImageBmp>> preloadAssets() async {
  List<String> assetNameList = [
    ('images/colorlarge.bmp'),
    ('images/rotologo.bmp'),
    ('images/nysmall.bmp'),
    ('images/woman.bmp'),
  ];
  var r = assetNameList
      .map((e) async =>
          ImageBmp(e, (await rootBundle.load(e)).buffer.asUint8List()))
      .toList();
  return Future.wait(r);
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key key}) : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImageData imageData = ImageData();

  String getMemHumanSize(int bytes) {
    var units =  [' bytes', ' KB', ' MB', ' GB']; 
    var pow = (bytes != 0 ? log(bytes) : 0) ~/ log(1024); 
    pow = min(pow, units.length - 1); 
    var size = bytes / (1 << (10 * pow)); 
    return size.toStringAsFixed(pow) + units[pow]; 
  }
  

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      var ll = <Widget>[];
      for (var e in user.bmpList) {
        ll.add(Stack(alignment: Alignment.center, children: <Widget>[
          Image.memory(e.bmpblob),
          Positioned(
            left: 10,
            top: 10,
            child: Text('Image size is ${getMemHumanSize(e.bmpblob.lengthInBytes)}'),
          )
        ]));
      }

      return user.image != null || user.waitingImage ?
        Scaffold(
          appBar: AppBar(
            title: const Text('Imagine Processing'),
          ),
          floatingActionButton:
            FloatingActionButton(
              tooltip: 'Dismiss',
              child: const Icon(Icons.close),
              onPressed: () async {
                try {
                  user.waitingImage = false;
                  user.image = null;
                  setState(() {});
                } catch (e) {
                  debugPrint(e.toString());
                }
              }),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.redAccent,
            child: Stack(
              alignment: Alignment.center, 
              children: <Widget>[
                user.waitingImage ? const CircularProgressIndicator() : Image.memory(user.image),
                Positioned(
                  left: 10,
                  top: 10,
                  child: user.waitingImage ? const Text('Loading..') : Text('Image size is ${getMemHumanSize(user.image.lengthInBytes)}'),
                )
              ]
            )
          )
        )
        : 
        Scaffold(
          appBar: AppBar(
            title: const Text('Imagine Processing'),
          ),
          floatingActionButton:
            Column(
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [
                FloatingActionButton(
                    tooltip: 'Send image',
                    child: const Icon(Icons.send),
                    heroTag: null,
                    onPressed: () async {
                      try {
                        user.waitingImage = true;
                        setState(() {});
                        final blob = user.bmpList[selectedIndex].bmpblob;
                        user.send("CMD_InvertImage@Main[${base64.encode(blob)}]");
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    }),
                const SizedBox(height: 10),
                FloatingActionButton(
                    tooltip: 'Add image',
                    child: const Icon(Icons.add_photo_alternate),
                    heroTag: null,
                    onPressed: () async {
                      await imageData.pickFile();
                      if (imageData.data != null) {
                        var bmp = ImageBmp('', imageData.data);
                        user.bmpList.insert(selectedIndex, bmp);
                        setState(() {});
                      }
                    }),
                const SizedBox(height: 10),
                FloatingActionButton(
                    tooltip: 'Delete image',
                    child: const Icon(Icons.delete_forever),
                    heroTag: null,
                    onPressed: () => {
                          (user.bmpList.isEmpty)
                              ? null
                              : {
                                  if (selectedIndex > (user.bmpList.length - 1))
                                    selectedIndex = user.bmpList.length - 1,
                                  user.bmpList.removeAt(selectedIndex),
                                  setState(() {})
                                }
                        }),
                ]
            ),
          body: ll.isEmpty
            ? const Center(child: Text('No images left'))
            : ImageSlideshow(
                /// Width of the [ImageSlideshow].
                width: double.infinity,

                /// Height of the [ImageSlideshow].
                height: double.infinity,

                /// The page to show when first creating the [ImageSlideshow].
                initialPage: selectedIndex,

                /// The color to paint the indicator.
                indicatorColor: Colors.blue,

                /// The color to paint behind th indicator.
                indicatorBackgroundColor: Colors.grey,

                /// The widgets to display in the [ImageSlideshow].
                children: ll,

                /// Called whenever the page in the center of the viewport changes.
                onPageChanged: ((value) => selectedIndex = value),

                /// Do not auto scroll with null or 0.
                autoPlayInterval: 0,

                /// Loops back to first slide.
                isLoop: true,
              ),
      );
    });
  }
}

