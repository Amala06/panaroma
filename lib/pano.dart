import 'package:panorama/panorama.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';
import 'package:image_picker/image_picker.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panorama Demo',
      theme: ThemeData.dark(),
home: MyHomePage(key: UniqueKey(), title: 'Panorama Demo'),
    );
  }
}
class MyHomePage extends StatefulWidget {
MyHomePage({required Key key, required this.title}) : super(key: key);
final String title;
@override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Panorama(
        zoom: 1,
        animSpeed: 1.0,
child: _imageFile != null
            ? Image.file(_imageFile!)
            : Image.asset('assets/e.png'),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          // _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
          // _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
var pickedFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          _imageFile = pickedFile != null ? File(pickedFile.path) : null;

          setState(() {});
        },
        child: Icon(Icons.panorama),
      ),
    );
  }
}

