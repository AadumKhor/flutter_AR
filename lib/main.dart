import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:arcore_plugin/arcore_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  final Directory systemTempDir = Directory.systemTemp;
  final File tempFile = File('${systemTempDir.path}/image_database.imgdb');

  // create tempfile
  await tempFile.create();

  rootBundle.load("assets/image_database.imgdb").then((data) {
    tempFile.writeAsBytesSync(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    runApp(MaterialApp(home: FLutterAR()));
  }).catchError((error) {
    throw Exception(error);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AR',
      debugShowCheckedModeBanner: false,
      home: FLutterAR(),
    );
  }
}

class FLutterAR extends StatefulWidget {
  @override
  _FLutterARState createState() => _FLutterARState();
}

class _FLutterARState extends State<FLutterAR> {
  ArCoreViewController _controller;
  double radius = 5.0;

  @override
  void initState() {
    super.initState();
  }

  _onViewCreated(ArCoreViewController _arController) {
    _controller = _arController;
    _controller.getArCoreView();
  }

  void _onImageRecognized(String recImgName) {
    print("image recongized: $recImgName");
    vector.Sphere()..radius = radius;
    // you can pause the image recognition via arCoreViewController.pauseImageRecognition();
    // resume it via arCoreViewController.resumeImageRecognition();
  }

  // _addSphere(ArCoreViewController _arController){
  //   final material =
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('FlutterAR'),
      ),
      body: Center(
        child: ArCoreView(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          onArCoreViewCreated: _onViewCreated,
          focusBox: Container(
            height: 400.0,
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(width: 2.0)),
          ),
        ),
      ),
    );
  }
}
