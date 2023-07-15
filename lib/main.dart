import 'package:better_open_file/better_open_file.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:async';
// import 'package:image_gallery_saver/image_gallery_saver.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(CameraAwesomeApp(camera: firstCamera));
}

class CameraAwesomeApp extends StatelessWidget {
  final CameraDescription camera;

  const CameraAwesomeApp({required this.camera, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CameraAwesome',
      home: CameraPage(camera: camera),
    );
  }
}

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({required this.camera, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  StreamSubscription<double>? _compassSubscription;
  double _heading = 0.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startCompass();
  }

List<String> array=[];

  void _initCamera() {
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  
  void _startCompass() {
    _compassSubscription!= FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading ?? 0.0;
      });
      
      if(array.length==13){
        print("Go for stitching");
      }
      if((_heading>=(-180+array.length*30))&& (_heading<=(-176+array.length*30))){
            _capturePhoto();
            // array.add(fi)

      }
    
    });
  }
  
  



  // Future<void> _capturePhoto() async {
  //   if (!_cameraController.value.isInitialized) {
  //     return;
  //   }

  //   final directory = await path_provider.getTemporaryDirectory();
  //   final String filePath = path.join(
  //       directory.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');

  //   if (_cameraController.value.isTakingPicture) {
  //     return;
  //   }

  //   try {
  //     await _cameraController.takePicture();
  //     print('Photo captured: $filePath');
  //     OpenFile.open(filePath);
  //     array.add(filePath);
  //     print("array length : is given below ");
  //     print(array.length);
  //     print("");
  //   } catch (e) {
  //     print('Failed to capture photo: $e');
  //   }
  // }

  Future<void> _capturePhoto() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    final directory = await path_provider.getExternalStorageDirectory();
    final folderPath = path.join(directory!.path, 'MyAppImages');
    final imagePath = path.join(
        folderPath, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');

    if (_cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await _cameraController.takePicture();
      print('Photo captured: $imagePath');
      array.add(imagePath);
      print('Array length: ${array.length}');
      print('');
    } catch (e) {
      print('Failed to capture photo: $e');
    }
  }


  // Future<void> _capturePhoto() async {
  //   if (!_cameraController.value.isInitialized) {
  //     return;
  //   }

  //   final directory = await path_provider.getTemporaryDirectory();
  //   final String filePath = path.join(
  //       directory.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');

  //   if (_cameraController.value.isTakingPicture) {
  //     return;
  //   }

  //   try {
  //     await _cameraController.takePicture();
  //     print('Photo captured: $filePath');
  //     // await ImageGallerySaver.saveFile(filePath);
  //     array.add(filePath);
  //     print("array length: ${array.length}");
  //     print("");
  //   } catch (e) {
  //     print('Failed to capture photo: $e');
  //   }
  // }





  @override
  void dispose() {
    _cameraController.dispose();
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            CameraPreview(_cameraController),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Heading: $_heading',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _capturePhoto,
      //   child: Icon(Icons.camera),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
