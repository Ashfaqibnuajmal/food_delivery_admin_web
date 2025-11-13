import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageProviderModel with ChangeNotifier {
  Uint8List? _pickedImage;
  Uint8List? get pickedImage => _pickedImage;
  void setImage(Uint8List? image) {
    _pickedImage = image;
    notifyListeners();
  }

  void clearImage() {
    _pickedImage = null;
    notifyListeners();
  }
}
