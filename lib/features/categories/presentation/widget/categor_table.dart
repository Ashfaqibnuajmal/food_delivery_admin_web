import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/header_cell.dart';
import 'package:user_app/features/categories/data/models/category_model.dart'
    show CategoryModel;
import 'package:user_app/features/categories/presentation/widget/delete_button.dart';
import 'package:user_app/features/categories/presentation/widget/edit_button.dart';
import 'package:user_app/features/categories/presentation/widget/image_preview_row.dart';

class CategoryTable extends StatelessWidget {
  final List<CategoryModel> categories;
  final TextEditingController catagorynameController;

  const CategoryTable({
    super.key,
    required this.categories,
    required this.catagorynameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.deepBlue,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: const Row(
            children: [
              HeaderCell("Images", flex: 3),
              HeaderCell("Name", flex: 2),
              HeaderCell("Edit", flex: 2),
              HeaderCell("Delete", flex: 2),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: AppColors.mediumBlue.withOpacity(0.25),
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                color: index.isEven
                    ? AppColors.lightBlue.withOpacity(0.04)
                    : AppColors.pureWhite.withOpacity(0.02),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ImagePreviewRow(imageUrls: category.imageUrls),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: EditButton(
                        category: category,
                        catagorynameController: catagorynameController,
                      ),
                    ),
                    Expanded(flex: 2, child: DeleteButton(category: category)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
