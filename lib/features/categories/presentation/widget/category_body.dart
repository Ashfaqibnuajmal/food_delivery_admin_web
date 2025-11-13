import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/confiorm_dilog.dart';
import 'package:user_app/features/categories/data/models/category_model.dart';
import 'package:user_app/features/categories/data/services/category_sevices.dart';
import 'package:user_app/features/categories/presentation/widget/add_category.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  TextEditingController catagorynameController = TextEditingController();

  Body({super.key, required this.catagorynameController});
  double sidebarWidth = 250;

  @override
  Widget build(BuildContext context) {
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
                  log(snapshot.error.toString());
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

                        // Body Rows
                        ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final value = categories[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue.withOpacity(0.1),
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
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: AppColors.pureWhite,
                                          image: DecorationImage(
                                            image: NetworkImage(value.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
                                        onPressed: () {
                                          catagorynameController =
                                              TextEditingController(
                                                text: value.name,
                                              );
                                          custemAddDialog(
                                            context: context,
                                            oldImage: value.imageUrl,
                                            controller: catagorynameController,
                                            onpressed: () async {
                                              final newImage = context
                                                  .read<ImageProviderModel>()
                                                  .pickedImage;
                                              final updatedCatagory = CategoryModel(
                                                categoryUid: value.categoryUid,
                                                imageUrl: newImage != null
                                                    ? await context
                                                              .read<
                                                                CategorySevices
                                                              >()
                                                              .sendImageToCloudinary(
                                                                newImage,
                                                              ) ??
                                                          value.imageUrl
                                                    : value.imageUrl,
                                                name:
                                                    catagorynameController.text,
                                              );
                                              // ignore: use_build_context_synchronously
                                              context
                                                  .read<CategorySevices>()
                                                  .editCategory(
                                                    updatedCatagory,
                                                    value.imageUrl,
                                                  );
                                              // ignore: use_build_context_synchronously
                                              if (Navigator.canPop(context)) {
                                                catagorynameController.clear();
                                                // ignore: use_build_context_synchronously
                                                context
                                                    .read<ImageProviderModel>()
                                                    .clearImage();
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                              }
                                            },
                                          );
                                        },
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
                                        onPressed: () {
                                          customDeleteDialog(context, () {
                                            context
                                                .read<CategorySevices>()
                                                .deleteCategory(value);
                                            Navigator.pop(context);
                                          });
                                        },
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
