import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/features/categories/provider/category_provider.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';

class CategoryHeader extends StatelessWidget {
  final TextEditingController catagorynameController;
  const CategoryHeader({super.key, required this.catagorynameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Categories", style: CustomTextStyles.loginHeading),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () => _openAddCategoryDialog(context),
            child: const Text(
              "Add Category",
              style: CustomTextStyles.addCategory,
            ),
          ),
        ],
      ),
    );
  }

  void _openAddCategoryDialog(BuildContext context) {
    custemAddDialog(
      context: context,
      controller: catagorynameController,
      onPressed: () async {
        final imageProvider = context.read<MultipleImageProvider>();
        final categoryProvider = context.read<CategoryProvider>(); // 👈 new
        final images = imageProvider.pickedImages;
        final name = catagorynameController.text.trim();

        // ─── Validation ──────────────────────────────────
        if (name.isEmpty || images.isEmpty) {
          customSnackbar(context, "Pick at least one photo", Colors.red);
          return;
        }

        // ─── Add via Provider ────────────────────────────
        final success = await categoryProvider.addCategory(
          name: name,
          images: images,
        );

        // ─── Result Feedback ─────────────────────────────
        if (success) {
          catagorynameController.clear();
          imageProvider.clearImages();
          if (Navigator.canPop(context)) Navigator.pop(context);
          customSnackbar(context, "Category added successfully!", Colors.green);
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
