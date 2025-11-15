import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/network_image_placeolder.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';

// ignore: must_be_immutable
class CategoryBody extends StatelessWidget {
  const CategoryBody({super.key, required this.catagorynameController});

  final TextEditingController catagorynameController;
  final double sidebarWidth = 250;

  @override
  Widget build(BuildContext context) {
    final logic = CategoryController();

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - sidebarWidth - 26.0,
            ),
            child: StreamBuilder<List<CategoryModel>>(
              stream: context.read<CategorySevices>().fetchCatagories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightBlue,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No categories found",
                      style: TextStyle(color: AppColors.pureWhite),
                    ),
                  );
                }

                final categories = snapshot.data!;

                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width > 600
                        ? 600
                        : MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.1),
                      border: Border.all(color: AppColors.mediumBlue, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: AppColors.deepBlue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Image",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Name",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Edit",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Delete",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content rows
                        ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final value = categories[index];

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.mediumBlue.withOpacity(
                                      0.5,
                                    ),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Image
                                  Expanded(
                                    child: Center(
                                      child: ShimmerNetworkImage(
                                        imageUrl: value.imageUrl,
                                        width: 40,
                                        height: 40,
                                        borderRadius: BorderRadius.circular(8),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // Name
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        value.name,
                                        style: const TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Edit Button
                                  Expanded(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () => logic.handleEdit(
                                          context,
                                          value,
                                          catagorynameController,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.deepBlue,
                                          foregroundColor: AppColors.pureWhite,
                                          minimumSize: const Size(60, 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Delete Button
                                  Expanded(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            logic.handleDelete(context, value),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: AppColors.pureWhite,
                                          minimumSize: const Size(60, 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
