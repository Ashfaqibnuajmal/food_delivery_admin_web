import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';

Future<void> showEditCategoryDialog({
  required BuildContext context,
  required String currentName,
  List<String>? oldImages,
  required void Function(String newName, List<Uint8List> newImages) onSave,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: currentName);
  final service = CategoryController();

  await showDialog(
    context: context,
    builder: (context) {
      final multiImageProvider = context.watch<MultipleImageProvider>();

      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🖼 Multiple Images Picker
                  GestureDetector(
                    onTap: () async {
                      await service.handleImagesPick(context);
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.mediumBlue,
                          width: 2,
                        ),
                        color: AppColors.darkBlue,
                      ),
                      child: multiImageProvider.hasImages
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: multiImageProvider.pickedImages.length,
                              itemBuilder: (context, index) {
                                final img =
                                    multiImageProvider.pickedImages[index];
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Image.memory(
                                        img,
                                        width: 150,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () => multiImageProvider
                                            .removeImage(index),
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : oldImages != null && oldImages.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: oldImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Image.network(
                                    oldImages[index],
                                    width: 150,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "Click here to add images!",
                                style: TextStyle(
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📝 Name Field
                  TextFormField(
                    controller: nameController,
                    decoration: inputDecoration("Category Name"),
                    validator: service.validateName,
                    style: const TextStyle(color: AppColors.pureWhite),
                  ),

                  const SizedBox(height: 25),

                  /// 💾 Save Button
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      service.handleSaveMultiple(
                        context: context,
                        controller: nameController,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: CustomTextStyles.addCategory,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
