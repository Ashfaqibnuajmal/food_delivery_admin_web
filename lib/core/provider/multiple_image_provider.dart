import 'dart:typed_data';
import 'package:flutter/material.dart';

class MultipleImageProvider with ChangeNotifier {
  /// Internal list of selected images
  final List<Uint8List> _pickedImages = [];

  /// Get selected images
  List<Uint8List> get pickedImages => List.unmodifiable(_pickedImages);

  /// Add single image
  void addImage(Uint8List image) {
    _pickedImages.add(image);
    notifyListeners();
  }

  /// Add multiple images at once
  void addImages(List<Uint8List> images) {
    _pickedImages.addAll(images);
    notifyListeners();
  }

  /// Replace all images with a new list
  void setImages(List<Uint8List> images) {
    _pickedImages
      ..clear()
      ..addAll(images);
    notifyListeners();
  }

  /// Remove image by index
  void removeImage(int index) {
    if (index >= 0 && index < _pickedImages.length) {
      _pickedImages.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear all images
  void clearImages() {
    _pickedImages.clear();
    notifyListeners();
  }

  /// Check if any image exists
  bool get hasImages => _pickedImages.isNotEmpty;
}
