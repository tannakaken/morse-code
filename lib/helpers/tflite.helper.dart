import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:morse_coder/helpers/image.helper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

const modelFilename = "assets/torch_model.tflite";
const labelsFilename = "assets/labels.txt";

Future<Interpreter> loadModel() async {
  //assetsからモデルを読み込む
  final options = InterpreterOptions();

  options.addDelegate(XNNPackDelegate());

  final interpreter =
      await Interpreter.fromAsset(modelFilename, options: options);
  debugPrint("load model");
  return interpreter;
}

Future<List<String>> loadLabels() async {
  //assetsからラベルファイルを読み込み、行ごとに配列に格納する
  final labels = await rootBundle.loadString(labelsFilename);
  debugPrint("load labels");
  return labels.split('\n');
}

double identifyImage(
    img.Image image, List<String> labels, Interpreter interpreter) {
  final input = convertImageToTensor(image); //画像をテンソルに変換
  final output = [List<double>.filled(labels.length, 0.0)]; //出力用の配列

  interpreter.run(input, output); //識別処理を実行

  final outputList = output[0]; //出力用の配列から、識別結果を取得
  final confidence = outputList.reduce((a, b) => a + b); //識別結果の一致率を計算

  return outputList[1] / confidence;
}
