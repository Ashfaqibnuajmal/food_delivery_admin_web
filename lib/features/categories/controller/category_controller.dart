import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/functions/image_functions.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';

class CategoryController {
  /// Pick an image and update provider
  Future<void> handleImagePick(BuildContext context) async {
    try {
      final image = await pickImage();
      // ignore: use_build_context_synchronously
      Provider.of<ImageProviderModel>(context, listen: false).setImage(image);
    } catch (e) {
      log("Image Pick Error: $e");
    }
  }

  /// Validate category name
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required"; // Return error if empty
    }
    return null; // Return null if valid
  }

  /// Pick new image for editing
  Future<void> pickImageForEdit(BuildContext context) async {
    try {
      final image = await pickImage();
      // Update provider with new image
      // ignore: use_build_context_synchronously
      context.read<ImageProviderModel>().setImage(image);
    } catch (e) {
      log("Image pick error: $e");
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
      customSnackbar(context, "Name cannot be empty", Colors.red); // Show error
      return;
    }

    onSave(newName); // Call save callback

    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close dialog/page
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
      oldImage: model.imageUrl,
      controller: controller,
      onPressed: () async {
        final imageProvider = context.read<ImageProviderModel>();
        final newImageFile = imageProvider.pickedImage;

        String finalImageURL = model.imageUrl;

        // Upload new image if selected
        if (newImageFile != null) {
          finalImageURL =
              await context.read<CategorySevices>().sendImageToCloudinary(
                newImageFile,
              ) ??
              model.imageUrl;
        }

        final updated = CategoryModel(
          categoryUid: model.categoryUid,
          imageUrl: finalImageURL,
          name: controller.text.trim(),
        );

        // Update category in service
        // ignore: use_build_context_synchronously
        context.read<CategorySevices>().editCategory(updated, model.imageUrl);

        controller.clear(); // Clear controller
        imageProvider.clearImage(); // Clear selected image

        // ignore: use_build_context_synchronously
        if (Navigator.canPop(context)) Navigator.pop(context); // Close dialog
      },
    );
  }

  /// Handle delete category
  void handleDelete(BuildContext context, CategoryModel model) {
    customDeleteDialog(context, () {
      context.read<CategorySevices>().deleteCategory(model); // Delete category
      Navigator.pop(context); // Close confirmation dialog
    });
  }
}
