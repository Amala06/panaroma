// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_opencv/flutter_opencv.dart';
// void main() => runApp(PhotosphereApp());

// class PhotosphereApp extends StatefulWidget {
//   @override
//   _PhotosphereAppState createState() => _PhotosphereAppState();
// }

// class _PhotosphereAppState extends State<PhotosphereApp> {
//   File? _image;
//   OpenCV? _openCV;

//   @override
//   void initState() {
//     super.initState();
//     _initializeOpenCV();
//   }

//   void _initializeOpenCV() async {
//     _openCV = await FlutterOpenCV.init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Photosphere Capture'),
//         ),
//         body: _image == null ? _buildCameraView() : _buildPhotosphereView(),
//       ),
//     );
//   }

//   Widget _buildCameraView() {
//     return CameraPreview(
//       onImageCaptured: (CameraImage image) {
//         setState(() {
//           _image = null;
//         });

//         _capturePhotosphere(image);
//       },
//     );
//   }

//   void _capturePhotosphere(CameraImage image) async {
//     try {
//       final photosphere = await _openCV!.capturePhotosphere(image);
//       setState(() {
//         _image = File(photosphere);
//       });
//     } catch (e) {
//       print('Error capturing Photosphere: $e');
//     }
//   }

//   Widget _buildPhotosphereView() {
//     return Container(
//       child: Image.file(_image!),
//     );
//   }

//   @override
//   void dispose() {
//     _openCV?.dispose();
//     super.dispose();
//   }
// }

import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';

void main() {
  runApp(const CameraAwesomeApp());
}

class CameraAwesomeApp extends StatelessWidget {
  const CameraAwesomeApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CameraAwesome',
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatelessWidget {
  //   StreamSubscription<double>? _compassSubscription;
//   double _heading = 0.0;

  const CameraPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photoAndVideo(
            photoPathBuilder: () => _customPath(CaptureMode.photo),
            videoPathBuilder: () => _customPath(CaptureMode.video),
            initialCaptureMode: CaptureMode.photo,
          ),
          enablePhysicalButton: true,
          filter: AwesomeFilter.AddictiveRed,
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_16_9,
          previewFit: CameraPreviewFit.fitWidth,
          onMediaTap: (mediaCapture) {
            OpenFile.open(mediaCapture.filePath);
          },
        ),
      ),
    );
  }

  Future<String> _customPath(CaptureMode mode) async {
    final directory = await path_provider.getTemporaryDirectory();
    String basePath = directory.path;

    if (mode == CaptureMode.photo) {
      return '$basePath/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } else if (mode == CaptureMode.video) {
      return '$basePath/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    }

    return '';
  }
}
// import 'package:better_open_file/better_open_file.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:flutter_compass/flutter_compass.dart';
// import 'dart:async';
// import 'package:my_app/main.dart';

// void main() {
//   runApp(const CameraAwesomeApp());
// }

// class CameraAwesomeApp extends StatelessWidget {
//   const CameraAwesomeApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'CameraAwesome',
//       home: CameraPage(),
//     );
//   }
// }

// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key});

//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   StreamSubscription<double>? _compassSubscription;
//   double _heading = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _startCompass();
//   }

//   void _startCompass() {
//     _compassSubscription!= FlutterCompass.events!.listen((event) {
//       setState(() {
//         _heading = event.heading ?? 0.0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _compassSubscription?.cancel();
//   }

//   Future<String> _customPath(CaptureMode mode) async {
//     final directory = await path_provider.getTemporaryDirectory();
//     String basePath = directory.path;

//     if (mode == CaptureMode.photo) {
//       return '$basePath/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     } else if (mode == CaptureMode.video) {
//       return '$basePath/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
//     }

//     return '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: CameraAwesomeBuilder.awesome(
//           saveConfig: SaveConfig.photoAndVideo(
//             photoPathBuilder: () => _customPath(CaptureMode.photo),
//             videoPathBuilder: () => _customPath(CaptureMode.video),
//             initialCaptureMode: CaptureMode.photo,
//           ),
//           enablePhysicalButton: true,
//           filter: AwesomeFilter.AddictiveRed,
//           flashMode: FlashMode.auto,
//           aspectRatio: CameraAspectRatios.ratio_16_9,
//           previewFit: CameraPreviewFit.fitWidth,
//           onMediaTap: (mediaCapture) {
//             OpenFile.open(mediaCapture.filePath);
//             print('Heading: $_heading'); // Access the phone's angle here
//           },
//         ),
//       ),
//     );
//   }
// }
