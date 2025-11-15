import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';

Future<void> showEditCategoryDialog({
  required BuildContext context,
  required String currentName,
  String? oldImage,
  required void Function(String newName) onSave,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: currentName);
  final service = CategoryController();

  await showDialog(
    context: context,
    builder: (context) {
      final imageProvider = context.watch<ImageProviderModel>();

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
                  /// 🖼 Image Picker UI (logic moved to service)
                  GestureDetector(
                    onTap: () => service.pickImageForEdit(context),
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
                      child: imageProvider.pickedImage != null
                          ? Image.memory(
                              imageProvider.pickedImage!,
                              fit: BoxFit.contain,
                            )
                          : oldImage != null
                          ? Image.network(oldImage, fit: BoxFit.contain)
                          : const Center(
                              child: Text(
                                "Click here to add image!",
                                style: TextStyle(
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📝 Name Field (validation moved to service)
                  TextFormField(
                    controller: nameController,
                    decoration: inputDecoration("Category Name"),
                    validator: service.validateName,
                    style: const TextStyle(color: AppColors.pureWhite),
                  ),

                  const SizedBox(height: 25),

                  /// 💾 Save Button (logic moved to service)
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      service.handleSave(
                        context: context,
                        controller: nameController,
                        onSave: onSave,
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
