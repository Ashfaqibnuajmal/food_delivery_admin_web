import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';
import 'package:user_app/features/categories/provider/category_provider.dart';

class EditButton extends StatelessWidget {
  final CategoryModel category;
  final TextEditingController catagorynameController;

  const EditButton({
    super.key,
    required this.category,
    required this.catagorynameController,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Center(
      child: ElevatedButton.icon(
        onPressed: categoryProvider.isLoading
            ? null
            : () => _openEditDialog(context, category, categoryProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepBlue,
          foregroundColor: AppColors.pureWhite,
          elevation: 0,
          minimumSize: const Size(86, 38),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.edit_rounded, size: 16),
        label: const Text("Edit", style: TextStyle(fontSize: 12)),
      ),
    );
  }

  void _openEditDialog(
    BuildContext context,
    CategoryModel value,
    CategoryProvider categoryProvider,
  ) {
    catagorynameController.text = value.name;

    custemAddDialog(
      context: context,
      oldImages: value.imageUrls,
      controller: catagorynameController,
      onPressed: () async {
        final imageProvider = context.read<MultipleImageProvider>();

        final success = await categoryProvider.editCategory(
          oldModel: value,
          newName: catagorynameController.text.trim(),
          newImages: imageProvider.pickedImages,
        );

        if (success) {
          catagorynameController.clear();
          imageProvider.clearImages();
          if (Navigator.canPop(context)) Navigator.pop(context);
          customSnackbar(
            context,
            "Category updated successfully!",
            Colors.green,
          );
        } else {
          customSnackbar(
            context,
            categoryProvider.errorMessage ?? "Something went wrong",
            Colors.red,
          );
        }
      },
    );
  }
}
