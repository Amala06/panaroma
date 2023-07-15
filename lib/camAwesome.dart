import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:async';
import 'dart:io';

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
    String folderName = "CameraAwesome";

    // Create a new folder (if it doesn't exist) to save the media
    Directory newFolder = Directory('$basePath/$folderName');
    if (!newFolder.existsSync()) {
      newFolder.createSync(recursive: true);
    }

    if (mode == CaptureMode.photo) {
      return '${newFolder.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } else if (mode == CaptureMode.video) {
      return '${newFolder.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    }

    return '';
  }
}
