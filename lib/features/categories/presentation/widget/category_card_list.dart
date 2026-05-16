import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/presentation/widget/delete_button.dart';
import 'package:user_app/features/categories/presentation/widget/edit_button.dart';
import 'package:user_app/features/categories/presentation/widget/image_preview_row.dart';

class CategoryCardList extends StatelessWidget {
  final List<CategoryModel> categories;
  final TextEditingController catagorynameController;

  const CategoryCardList({
    super.key,
    required this.categories,
    required this.catagorynameController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = categories[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.deepBlue.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.mediumBlue.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePreviewRow(imageUrls: category.imageUrls),
              const SizedBox(height: 14),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: EditButton(
                      category: category,
                      catagorynameController: catagorynameController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: DeleteButton(category: category)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
