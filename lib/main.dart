import "dart:io";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:morse_coder/about_page.dart";
import "package:morse_coder/camera_page.dart";
import "package:morse_coder/helpers/morse.helper.dart";
import "package:morse_coder/helpers/time.helper.dart";
import "package:torch_light/torch_light.dart";
import "package:flutter_watch_os_connectivity/flutter_watch_os_connectivity.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "モールス送受信",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: "モールス送受信"),
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
  final TextEditingController _controller = TextEditingController();
  final FlutterWatchOsConnectivity _flutterWatchOsConnectivity =
      FlutterWatchOsConnectivity();
  String _text = "";
  bool _hasError = false;
  bool _lighting = false;
  bool _looping = false;
  void _onChangeText(String newText) {
    final normalized = newText.toLowerCase();
    setState(() {
      _text = normalized;
      _hasError = stringToMorse(normalized) == null;
    });
    sendMessage(newText);
  }

  void _showIndicatorDialog() {
    setState(() {
      _lighting = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(children: <Widget>[
            const Center(child: Text("送信中", style: TextStyle(fontSize: 30.0))),
            const SizedBox(
                width: 50.0,
                height: 50.0,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.lightBlue))),
            CheckboxListTile(
              value: _looping,
              onChanged: (_) {
                setState(() {
                  _looping = !_looping;
                });
              },
              title: const Text("ループ"),
              secondary: const Icon(Icons.loop_rounded),
            ),
            OutlinedButton(
                onPressed: _hideIndicatorDialog, child: const Text("停止")),
          ]);
        });
      },
    );
  }

  void _hideIndicatorDialog() {
    setState(() {
      _lighting = false;
      _looping = false;
    });
    Navigator.maybePop(context);
  }

  Future<void> _checkAndSleep(int milliseconds) async {
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
      while (true) {
        for (final char in seq) {
          for (final atom in char) {
            await TorchLight.enableTorch();
            switch (atom) {
              case MorseAtom.dit:
                await _checkAndSleep(morseUnitMilliseconds);
                break;
              case MorseAtom.dah:
                await _checkAndSleep(morseLongMilliseconds);
                break;
            }
            await TorchLight.disableTorch();
            await _checkAndSleep(morseUnitMilliseconds);
          }
          await _checkAndSleep(morseBetweenDurationMilliseconds);
        }
        if (_looping) {
          await _checkAndSleep(morseLongDurationMilliseconds);
        } else {
          break;
        }
      }
      _hideIndicatorDialog();
    } on LightingCancel {
      // 特に何もしない
    } finally {
      await TorchLight.disableTorch();
    }
  }

  void _openCamera() {
    availableCameras().then((cameras) {
      final navigator = Navigator.of(context);
      navigator.push(MaterialPageRoute(
          builder: (context) => CameraPage(
                camera: cameras[0],
              ),
          fullscreenDialog: true));
    });
  }

  void _openAbout() {
    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(
        builder: (context) => const AboutPage(), fullscreenDialog: true));
  }

  Future<void> sendMessage(String txt) async {
    if (Platform.isIOS) {
      bool isReachable = await _flutterWatchOsConnectivity.getReachability();
      if (isReachable) {
        await _flutterWatchOsConnectivity.sendMessage({"code": txt});
      } else {
        debugPrint("no associated watch");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _flutterWatchOsConnectivity.configureAndActivateSession();
      _flutterWatchOsConnectivity.activationStateChanged
          .listen((activationState) {
        if (activationState == ActivationState.activated) {
          sendMessage(_text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _openAbout,
            icon: const Icon(Icons.question_mark_outlined),
            color: Colors.white,
            tooltip: "このアプリについて",
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "モールス信号にしたい文字列を入力してください。",
            ),
            const Text(
              "（現在は英数字と一部の記号しか送受信できません。）",
            ),
            SizedBox(
              height: 200,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: _onChangeText,
                decoration: InputDecoration(
                    suffixIcon: Visibility(
                        visible: _text.isNotEmpty,
                        child: IconButton(
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _text = "";
                              _hasError = false;
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            semanticLabel: "送信文字列消去",
                          ),
                        )),
                    labelText: "送信文字列",
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                      (_) {
                        final Color color = _hasError
                            ? Theme.of(context).colorScheme.error
                            : Colors.green;
                        return TextStyle(color: color, letterSpacing: 1.3);
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    errorText: _hasError ? "送信できない文字が含まれています。" : null),
              ),
            ),
            Visibility(
                visible: !_hasError && _text.isNotEmpty,
                child:
                    ElevatedButton(onPressed: _torch, child: const Text("送信")))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "camera",
        onPressed: _openCamera,
        tooltip: "受信用カメラ",
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
