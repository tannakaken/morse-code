import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:morse_coder/helpers/morse.helper.dart';

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
  int _whenOnMilliSeconds = 0;
  int _whenOffMilliSeconds = 0;
  List<MorseAtom> data = [];
  String _currentMorse = "";
  String _result = "";
  bool _started = false;
  int? _threshold;
  int threshold() {
    return _threshold ?? 200;
  }

  static const int range = 7;

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
      _whenOffMilliSeconds = DateTime.now().millisecondsSinceEpoch;
      _controller.startImageStream((cameraImage) async {
        if (!_started) {
          return;
        }
        if (cameraImage.format.group == ImageFormatGroup.yuv420) {
          final int width = cameraImage.width;
          final int height = cameraImage.height;
          final int centerX = width ~/ 2;
          final int centerY = height ~/ 2;
          int luminanceSum = 0;
          int count = 0;
          for (var x = centerX - -range; x <= centerX + range; x++) {
            for (var y = centerY - -range; y <= centerY + range; y++) {
              final int index = x + (y * width);
              luminanceSum += cameraImage.planes[0].bytes[index];
              count += 1;
            }
          }
          final int luminanceAverage = luminanceSum ~/ count;
          _threshold ??= (255 + luminanceAverage) ~/ 2;
          final bool on = luminanceAverage > threshold();
          if (!on && !_on) {
            // ずっとoff
            final now = DateTime.now().millisecondsSinceEpoch;
            final interval = now - _whenOffMilliSeconds;
            if (data.isNotEmpty && interval > morseUnitMilliseconds * 2) {
              final c = morseToChar(data);
              if (c != null) {
                setState(() {
                  _result += c;
                });
              }
              data = [];
              setState(() {
                _currentMorse = "";
              });
            }
          } else if (!_on && on) {
            // 光り始めた
            _whenOnMilliSeconds = DateTime.now().millisecondsSinceEpoch;
          } else if (_on && !on) {
            // 暗くなった
            _whenOffMilliSeconds = DateTime.now().millisecondsSinceEpoch;
            final onInterval =
                _whenOffMilliSeconds - _whenOnMilliSeconds; // 光っていた時間
            debugPrint(onInterval.toString());
            final unitDiff = onInterval - morseUnitMilliseconds;
            if (unitDiff.abs() < 100) {
              data.add(MorseAtom.dit);
            } else {
              final longDiff = onInterval - morseLongMilliseconds;
              if (longDiff.abs() < 100) {
                data.add(MorseAtom.dah);
              } else {
                setState(() {
                  data = [];
                  _currentMorse = "unknown";
                });
              }
            }
          }
          _on = on;
          setState(() {
            _currentMorse = data.map((atom) => atom.display).join("");
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
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
        Stack(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 1,
                child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                        width: size,
                        height: size,
                        child: CameraPreview(_controller)))),
            Positioned(
                top: size / 2 - 10,
                left: size / 2 - 10,
                child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue))))
          ],
        ),
        Slider(
          value: _zoom,
          onChanged: zoom,
          min: 1.0,
          max: _maxZoom,
        ),
        Text(_on ? "ON" : "OFF"),
        Text(_currentMorse),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectableText(_result),
            Visibility(
                visible: _result.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _result = "";
                      });
                    },
                    icon: const Icon(Icons.cancel_outlined))),
            Visibility(
                visible: _result.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      if (_result.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: _result));
                        Fluttertoast.showToast(
                            msg: "クリップボードにコピーしました。",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    icon: const Icon(Icons.copy_all_outlined)))
          ],
        ),
        ElevatedButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text("戻る")),
      ]),
      floatingActionButton: GestureDetector(
          onTapDown: (_) {
            _started = true;
          },
          onTapUp: (_) {
            _started = false;
            _threshold = null;
          },
          child: FloatingActionButton(
            onPressed: () {},
            tooltip: 'start',
            child: const Icon(Icons.camera),
          )),
    );
  }
}
