import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
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
              backgroundColor: AppColors.mediumBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () => categoryCustomAddDialog(context),
            child: const Text(
              "Add Category",
              style: CustomTextStyles.addCategory,
            ),
          ),
        ],
      ),
    );
  }

  categoryCustomAddDialog(BuildContext context) {
    custemAddDialog(
      context: context,
      controller: catagorynameController,
      onPressed: () async {
        final imageProvider = context.read<MultipleImageProvider>();
        final images = imageProvider.pickedImages;
        final name = catagorynameController.text.trim();

        if (name.isEmpty || images.isEmpty) {
          return customSnackbar(context, "Pick at least one photo", Colors.red);
        }

        try {
          final uploadedUrls = <String>[];
          for (var image in images) {
            final url = await context
                .read<CategorySevices>()
                .sendImageToCloudinary(image);
            if (url != null) uploadedUrls.add(url);
          }

          await context.read<CategorySevices>().addCategory(name, uploadedUrls);

          if (Navigator.canPop(context)) {
            catagorynameController.clear();
            imageProvider.clearImages();
            Navigator.pop(context);
          }
        } catch (e) {
          customSnackbar(context, "Failed to add category: $e", Colors.red);
        }
      },
    );
  }
}
