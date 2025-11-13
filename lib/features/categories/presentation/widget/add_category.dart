import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/functions/image_functions.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/customtextfield.dart';

custemAddDialog({
  required BuildContext context,
  String? oldImage,
  required TextEditingController controller,
  required void Function() onpressed,
}) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🖼 Image Picker
              GestureDetector(
                onTap: () async {
                  try {
                    final image = await pickImage();
                    imageProvider.setImage(image);
                  } catch (e) {
                    log(e.toString());
                  }
                },
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

              // 📝 Category Name TextField
              CustemTextFIeld(
                hintText: "Enter category name",
                controller: controller,
              ),

              const SizedBox(height: 20),

              // ➕ Add Category Button
              ElevatedButton(
                onPressed: onpressed,
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
      );
    },
  );
}
