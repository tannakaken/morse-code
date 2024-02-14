import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// カメラ画面
class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<CameraPage> createState() => _CameraState();
}

class _CameraState extends State<CameraPage> {
  late CameraController _controller;
  bool initialized = false;
  int total = 0;
  int uploaded = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.low,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    _controller.initialize().then((value) {
      debugPrint("initialized");
      setState(() {
        initialized = true;
      });
      _controller.startImageStream((image) async {
        if (image.format.group == ImageFormatGroup.yuv420) {
          int sum = 0;
          final int width = image.width;
          final int height = image.height;
          for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
              final int index = x + (y * width);
              final int luminance = image.planes[0].bytes[index];
              sum += luminance;
            }
          }
          final average = sum / (width * height);
          debugPrint(average.toString());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      debugPrint("not initialized");
      return Container();
    }
    debugPrint("rendering");
    return Scaffold(
      body: Column(children: [
        CameraPreview(_controller),
        ElevatedButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text("戻る")),
      ]),
    );
  }
}
