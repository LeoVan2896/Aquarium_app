import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/chart_reader.dart';

enum PhotoSource { camera, gallery }

abstract interface class ChartScanner {
  // Null when the user backs out of the camera or picker.
  Future<List<ChartToken>?> scan(PhotoSource source);
}

class MlKitChartScanner implements ChartScanner {
  final _picker = ImagePicker();

  @override
  Future<List<ChartToken>?> scan(PhotoSource source) async {
    final photo = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 2400,
    );
    if (photo == null) return null;

    final recognizer = TextRecognizer();
    try {
      final text = await recognizer.processImage(
        InputImage.fromFilePath(photo.path),
      );
      return [
        for (final block in text.blocks)
          for (final line in block.lines)
            for (final element in line.elements)
              ChartToken(
                element.text,
                left: element.boundingBox.left,
                top: element.boundingBox.top,
                right: element.boundingBox.right,
                bottom: element.boundingBox.bottom,
              ),
      ];
    } finally {
      await recognizer.close();
    }
  }
}
