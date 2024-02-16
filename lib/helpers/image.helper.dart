import 'package:camera/camera.dart';
import 'package:image/image.dart';

List<List<List<List<num>>>> convertImageToTensor(Image inputImage) {
  final targetSize = inputImage.height > inputImage.width
      ? inputImage.width
      : inputImage.height;
  final offsetX = inputImage.height > inputImage.width
      ? 0
      : (inputImage.width - inputImage.height) ~/ 2;
  final offsetY = inputImage.height > inputImage.width
      ? (inputImage.height - inputImage.width) ~/ 2
      : 0;
  final inputImageCrop = copyCrop(inputImage,
      x: offsetX, y: offsetY, width: targetSize, height: targetSize);
  final inputImageResize = copyResize(inputImageCrop,
      height: 224, width: 224); //適した画像サイズに変換（Android用サイズ）

//Modelで読み込めるように、画像をテンソルに変換
  final imageMatrix = List.generate(1, (index) {
    return List.generate(
        inputImageResize.height,
        (y) => List.generate(inputImageResize.width, (x) {
              final pixel = inputImageResize.getPixel(x, y);
              return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
            }));
  });
  return imageMatrix;
}

Image convertBGRA8888ToImage(CameraImage cameraImage) {
  return Image.fromBytes(
    width: cameraImage.planes[0].width!,
    height: cameraImage.planes[0].height!,
    bytes: cameraImage.planes[0].bytes.buffer,
    order: ChannelOrder.bgra,
  );
}

///
/// Converts a [CameraImage] in YUV420 format to [image_lib.Image] in RGB format
///
Image convertYUV420ToImage(CameraImage cameraImage) {
  final imageWidth = cameraImage.width;
  final imageHeight = cameraImage.height;

  final yBuffer = cameraImage.planes[0].bytes;
  final uBuffer = cameraImage.planes[1].bytes;
  final vBuffer = cameraImage.planes[2].bytes;

  final int yRowStride = cameraImage.planes[0].bytesPerRow;
  final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

  final int uvRowStride = cameraImage.planes[1].bytesPerRow;
  final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

  final image = Image(width: imageWidth, height: imageHeight);

  for (int h = 0; h < imageHeight; h++) {
    int uvh = (h / 2).floor();

    for (int w = 0; w < imageWidth; w++) {
      int uvw = (w / 2).floor();

      final yIndex = (h * yRowStride) + (w * yPixelStride);

      // Y plane should have positive values belonging to [0...255]
      final int y = yBuffer[yIndex];

      // U/V Values are subsampled i.e. each pixel in U/V chanel in a
      // YUV_420 image act as chroma value for 4 neighbouring pixels
      final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

      // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
      // [0, 255] range they are scaled up and centered to 128.
      // Operation below brings U/V values to [-128, 127].
      final int u = uBuffer[uvIndex];
      final int v = vBuffer[uvIndex];

      // Compute RGB values per formula above.
      int r = (y + v * 1436 / 1024 - 179).round();
      int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
      int b = (y + u * 1814 / 1024 - 227).round();

      r = r.clamp(0, 255);
      g = g.clamp(0, 255);
      b = b.clamp(0, 255);

      image.setPixelRgb(w, h, r, g, b);
    }
  }

  return image;
}
