import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';

custemAddDialog({
  required BuildContext context,
  String? oldImage,
  required TextEditingController controller,
  required VoidCallback onPressed,
}) {
  final formKey = GlobalKey<FormState>();
  final service = CategoryController();

  return showDialog(
    context: context,
    builder: (context) {
      final imageProvider = Provider.of<ImageProviderModel>(context);

      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🖼 Image Picker
                GestureDetector(
                  onTap: () => service.handleImagePick(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mediumBlue, width: 2),
                      color: AppColors.darkBlue,
                    ),
                    height: 200,
                    width: double.infinity,
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

                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: inputDecoration("Name"),
                  validator: service.validateName,
                  style: const TextStyle(color: AppColors.pureWhite),
                ),

                const SizedBox(height: 20),

                // ➕ Button
                ElevatedButton(
                  onPressed: onPressed,
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
                    "Add Category",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
