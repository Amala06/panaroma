import 'package:better_open_file/better_open_file.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;

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
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startCompass();
  }

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
    _compassSubscription = FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading ?? 0.0;
      });

      if (imagePaths.length == 13) {
        print("Go for stitching");
        _stitchImages();
      }
      if ((_heading >= (-180 + imagePaths.length * 30)) &&
          (_heading <= (-176 + imagePaths.length * 30))) {
        _capturePhoto();
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    final directory = await path_provider.getTemporaryDirectory();
    final String filePath = path.join(
        directory.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');

    if (_cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await _cameraController.takePicture();
      print('Photo captured: $filePath');
      OpenFile.open(filePath);
      imagePaths.add(filePath);
      print("Array length: ${imagePaths.length}\n");
    } catch (e) {
      print('Failed to capture photo: $e');
    }
  }

  Future<void> _stitchImages() async {
    List<img.Image> images = [];
    for (String path in imagePaths) {
      img.Image? image = img.decodeImage(File(path).readAsBytesSync());
      if (image != null) {
        images.add(image);
      }
    }

    int maxWidth = images.map((image) => image.width).reduce((a, b) => a + b);
    int totalHeight = images.first.height;

    img.Image finalImage = img.Image(maxWidth, totalHeight);
    int offsetX = 0;
    for (img.Image image in images) {
      finalImage = img.copyInto(finalImage, image, dstX: offsetX);
      offsetX += image.width;
    }

    final directory = await path_provider.getTemporaryDirectory();
    final String stitchedImagePath = path.join(directory.path,
        'panorama_${DateTime.now().millisecondsSinceEpoch}.jpg');

    File(stitchedImagePath).writeAsBytesSync(img.encodeJpg(finalImage));

    print('Panorama image saved: $stitchedImagePath');
    OpenFile.open(stitchedImagePath);
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
