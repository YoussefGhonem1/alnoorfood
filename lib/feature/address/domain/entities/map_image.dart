
import 'dart:typed_data';

import '../../../../core/helper_function/helper_function.dart';

class MapImageClass{
  static MapImageClass? _instance;
  late Uint8List _imageBytes;
  MapImageClass._();
  static MapImageClass get instance {
    _instance ??= MapImageClass._(); // Instantiate if null
    return _instance!;
  }
  Future<void> loadImage(String assetPath) async {
    _imageBytes = await getBytesFromAsset(assetPath, 50);
  }
  Uint8List get imageBytes => _imageBytes;
}