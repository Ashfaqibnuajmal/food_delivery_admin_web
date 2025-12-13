import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/functions/image_function_multiple.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';

class CategoryController {
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

  /// Validate category name
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    return null;
  }

  /// Pick new images for editing (append to existing)
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

  /// Save category with multiple images
  Future<void> handleSaveMultiple({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final name = controller.text.trim();
    final imageProvider = context.read<MultipleImageProvider>();
    final images = imageProvider.pickedImages;

    if (name.isEmpty || images.isEmpty) {
      customSnackbar(
        context,
        "Enter name and pick at least one image",
        Colors.red,
      );
      return;
    }

    try {
      await context.read<CategorySevices>().addCategory(
        name,
        images.cast<String>(),
      );

      // Clear after save
      if (Navigator.canPop(context)) {
        controller.clear();
        imageProvider.clearImages();
        Navigator.pop(context);
      }
    } catch (e) {
      customSnackbar(context, "Failed to add category: $e", Colors.red);
    }
  }

  /// Handle save button action
  Future<void> handleSave({
    required BuildContext context,
    required TextEditingController controller,
    required void Function(String newName) onSave,
  }) async {
    final newName = controller.text.trim();

    if (newName.isEmpty) {
      customSnackbar(context, "Name cannot be empty", Colors.red);
      return;
    }

    onSave(newName);

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Handle edit category flow
  Future<void> handleEdit(
    BuildContext context,
    CategoryModel model,
    TextEditingController controller,
  ) async {
    controller.text = model.name; // Pre-fill name

    custemAddDialog(
      context: context,
      oldImages: model.imageUrls, // Updated
      controller: controller,
      onPressed: () async {
        final imageProvider = context.read<MultipleImageProvider>();
        final newImages = imageProvider.pickedImages;

        List<String> finalImageUrls = model.imageUrls;

        // Upload new images if selected
        if (newImages.isNotEmpty) {
          final uploadedUrls = <String>[];
          for (var img in newImages) {
            final url = await context
                .read<CategorySevices>()
                .sendImageToCloudinary(img);
            if (url != null) uploadedUrls.add(url);
          }
          // Combine old + new
          finalImageUrls = [...model.imageUrls, ...uploadedUrls];
        }

        final updated = CategoryModel(
          categoryUid: model.categoryUid,
          name: controller.text.trim(),
          imageUrls: finalImageUrls,
        );

        // Update category in service
        await context.read<CategorySevices>().editCategory(
          updated,
          model.imageUrls,
        );

        controller.clear();
        imageProvider.clearImages();

        if (Navigator.canPop(context)) Navigator.pop(context);
      },
    );
  }

  /// Handle delete category
  void handleDelete(BuildContext context, CategoryModel model) {
    customDeleteDialog(context, () {
      context.read<CategorySevices>().deleteCategory(model);
      Navigator.pop(context);
    });
  }

  Future<void> handleMultipleImagePick(BuildContext context) async {
    try {
      final images = await pickMultipleImages();
      if (images != null && images.isNotEmpty) {
        context.read<MultipleImageProvider>().setImages(images);
      }
    } catch (e) {
      log("Error picking multiple images: $e");
    }
  }

  // Future<void> pickMultipleImages(BuildContext context) async {
  //   try {
  //     final images = await pickMultipleImages();
  //     if (images.isNotEmpty) {
  //       context.read<MultipleImageProvider>().addImages(images);
  //     }
  //   } catch (e) {
  //     log("Error picking multiple images: $e");
  //   }
  // }
}
