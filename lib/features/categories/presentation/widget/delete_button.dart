import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/provider/category_provider.dart';

class DeleteButton extends StatelessWidget {
  final CategoryModel category;

  const DeleteButton({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Center(
      child: ElevatedButton.icon(
        onPressed: categoryProvider.isLoading
            ? null
            : () => _handleDelete(context, category, categoryProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: AppColors.pureWhite,
          elevation: 0,
          minimumSize: const Size(96, 38),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.delete_rounded, size: 16),
        label: const Text("Delete", style: TextStyle(fontSize: 12)),
      ),
    );
  }

  void _handleDelete(
    BuildContext context,
    CategoryModel value,
    CategoryProvider categoryProvider,
  ) {
    customDeleteDialog(context, () async {
      final success = await categoryProvider.deleteCategory(value);

      if (Navigator.canPop(context)) Navigator.pop(context);

      if (success) {
        customSnackbar(context, "Category deleted!", Colors.green);
      } else {
        customSnackbar(
          context,
          categoryProvider.errorMessage ?? "Failed to delete",
          Colors.red,
        );
      }
    });
  }
}
