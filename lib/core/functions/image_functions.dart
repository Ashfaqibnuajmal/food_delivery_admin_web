import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    return image.readAsBytes();
  }
  return null;
}
