import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:morse_coder/camera_page.dart';
import 'package:morse_coder/helpers/morse.helper.dart';
import 'package:morse_coder/helpers/tflite.helper.dart';
import 'package:morse_coder/helpers/time.helper.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class LightingCancel {}

class _MyHomePageState extends State<MyHomePage> {
  String _text = "";
  bool _hasError = false;
  bool _lighting = false;
  void _onChangeText(String newText) {
    if (stringToMorse(newText) == null) {
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _text = newText;
        _hasError = false;
      });
    }
  }

  void _showIndicatorDialog() {
    setState(() {
      _lighting = true;
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(children: <Widget>[
            const Center(child: Text("送信中", style: TextStyle(fontSize: 30.0))),
            const SizedBox(
                width: 50.0,
                height: 50.0,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.lightBlue))),
            OutlinedButton(
                onPressed: _hideIndicatorDialog, child: const Text("キャンセル"))
          ]);
        });
  }

  void _hideIndicatorDialog() {
    setState(() {
      _lighting = false;
    });
    Navigator.maybePop(context);
  }

  Future<void> checkAndSleep(int milliseconds) async {
    if (!_lighting) {
      throw LightingCancel();
    }
    await sleep(milliseconds);
    if (!_lighting) {
      throw LightingCancel();
    }
  }

  Future<void> _torch() async {
    final seq = stringToMorse(_text);
    if (seq == null) {
      return;
    }
    _showIndicatorDialog();
    try {
      for (final char in seq) {
        for (final atom in char) {
          await TorchLight.enableTorch();
          switch (atom) {
            case MorseAtom.dit:
              await checkAndSleep(morseUnitMilliseconds);
              break;
            case MorseAtom.dah:
              await checkAndSleep(morseLongMilliseconds);
              break;
          }
          await TorchLight.disableTorch();
          await checkAndSleep(morseUnitMilliseconds);
        }
        await checkAndSleep(morseBetweenDurationMilliseconds);
      }
      _hideIndicatorDialog();
    } on LightingCancel {
      // 特に何もしない
    } finally {
      await TorchLight.disableTorch();
    }
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final navigator = Navigator.of(context);
    final labels = await loadLabels();
    final interpreter = await loadModel();
    navigator.push(MaterialPageRoute(
        builder: (context) => CameraPage(
              camera: cameras[0],
              labels: labels,
              interpreter: interpreter,
            ),
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("モールス信号送受信機"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'モールス信号にしたい文字列を入力してください。',
            ),
            const Text(
              '（現在は英数字しか送受信できません。）',
            ),
            SizedBox(
              height: 200,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: _onChangeText,
              ),
            ),
            Visibility(
                visible: _hasError,
                child: const Text("送信できない文字が含まれています。",
                    style: TextStyle(color: Colors.red))),
            Visibility(
                visible: !_hasError,
                child:
                    ElevatedButton(onPressed: _torch, child: const Text("送信")))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        tooltip: 'open camera',
        child: const Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
