import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// Pick multiple images from gallery
Future<List<Uint8List>> pickMultipleImages() async {
  final picker = ImagePicker();
  final List<XFile>? images = await picker.pickMultiImage();

  if (images != null && images.isNotEmpty) {
    // Convert all XFile to Uint8List
    final List<Uint8List> imageBytes = [];
    for (var img in images) {
      final bytes = await img.readAsBytes();
      imageBytes.add(bytes);
    }
    return imageBytes;
  }

  return []; // Return empty list if no image selected
}
