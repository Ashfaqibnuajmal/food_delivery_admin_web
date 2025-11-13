import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';

class Header extends StatelessWidget {
  final TextEditingController catagorynameController;
  const Header({super.key, required this.catagorynameController});

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
      onpressed: () async {
        final imageProvider = context.read<ImageProviderModel>();
        final image = imageProvider.pickedImage;
        final name = catagorynameController.text.trim();
        if (name.isEmpty || image == null) {
          return customSnackbar(context, "Pick a photo", Colors.red);
        }
        await context.read<CategorySevices>().addCategory(name, image);
        // ignore: use_build_context_synchronously
        if (Navigator.canPop(context)) {
          catagorynameController.clear();
          imageProvider.clearImage();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      },
    );
  }
}
