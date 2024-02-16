import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:morse_coder/helpers/image.helper.dart';
import 'package:morse_coder/helpers/tflite.helper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// カメラ画面
class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.camera,
    required this.labels,
    required this.interpreter,
  }) : super(key: key);

  final CameraDescription camera;
  final List<String> labels;
  final Interpreter interpreter;

  @override
  State<CameraPage> createState() => _CameraState();
}

// inferenceへ渡す引数
// 引数はトップレベル関数である必要がある
// 引数にクラスのインスタンスや、staticメソッドを含むと
// Isolateへ渡すことができない
class IsolateData {
  IsolateData({
    required this.cameraImage,
    required this.interpreterAddress,
    required this.labels,
  });
  final CameraImage cameraImage;
  final int interpreterAddress;
  final List<String> labels;
}

class _CameraState extends State<CameraPage> {
  late CameraController _controller;
  bool initialized = false;
  double _zoom = 1.0;
  double _maxZoom = 1.0;
  bool _on = false;
  int frame = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.low,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    _controller.setExposureMode(ExposureMode.locked);
    _controller.initialize().then((value) {
      debugPrint("initialized");
      setState(() {
        initialized = true;
      });
      _controller.getMaxZoomLevel().then((max) {
        setState(() {
          _maxZoom = max;
        });
      });
      _controller.startImageStream((cameraImage) async {
        frame++;
        if (frame < 8) {
          return;
        }
        frame = 0;
        if (cameraImage.format.group == ImageFormatGroup.yuv420) {
          final probability = await compute(
              inference,
              IsolateData(
                  cameraImage: cameraImage,
                  interpreterAddress: widget.interpreter.address,
                  labels: widget.labels));
          debugPrint(probability.toString());
          setState(() {
            _on = probability > 0.3;
          });
        }
      });
    });
  }

  void zoom(double newZoom) {
    _controller.setZoomLevel(newZoom);
    setState(() {
      _zoom = newZoom;
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
        Slider(
          value: _zoom,
          onChanged: zoom,
          min: 1.0,
          max: _maxZoom,
        ),
        Text(_on ? "ON" : "OFF"),
        ElevatedButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text("戻る")),
      ]),
    );
  }

  static double inference(IsolateData isolateData) {
    var image = convertYUV420ToImage(
      isolateData.cameraImage,
    );

    final interpreter = Interpreter.fromAddress(
      isolateData.interpreterAddress,
    );

    return identifyImage(image, isolateData.labels, interpreter);
  }
}
