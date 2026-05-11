import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/functions/image_function_multiple.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';

class CategoryController {
  // ─── Pick Images (Add) ───────────────────────────────────
  Future<void> handleImagesPick(BuildContext context) async {
    try {
      final images = await pickMultipleImages();
      if (images.isNotEmpty) {
        context.read<MultipleImageProvider>().addImages(images);
      }
    } catch (e) {
      log("Image Pick Error: $e");
    }
  }

  // ─── Pick Images (Edit) ──────────────────────────────────
  Future<void> pickImagesForEdit(BuildContext context) async {
    try {
      final images = await pickMultipleImages();
      if (images.isNotEmpty) {
        context.read<MultipleImageProvider>().addImages(images);
      }
    } catch (e) {
      log("Image pick error: $e");
    }
  }
}
