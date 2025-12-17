import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';

custemAddDialog({
  required BuildContext context,
  required TextEditingController controller,
  required Future<void> Function() onPressed, // <-- change type
  List<String>? oldImages, // optional existing images for edit
}) {
  final formKey = GlobalKey<FormState>();
  final service = CategoryController();

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isUploading = false;
          final imageProvider = Provider.of<MultipleImageProvider>(context);

          return Dialog(
            backgroundColor: AppColors.deepBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🖼 Image Picker (horizontal scroll)
                    GestureDetector(
                      onTap: () async =>
                          await service.handleMultipleImagePick(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.mediumBlue,
                            width: 2,
                          ),
                          color: AppColors.darkBlue,
                        ),
                        height: 200,
                        width: double.infinity,
                        child: imageProvider.pickedImages.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageProvider.pickedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.memory(
                                      imageProvider.pickedImages[index],
                                      width: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              )
                            : (oldImages != null && oldImages.isNotEmpty)
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: oldImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      oldImages[index],
                                      width: 180,
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

                    TextFormField(
                      controller: controller,
                      enabled: !isUploading,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration("Category Name"),
                      validator: service.validateName,
                      style: const TextStyle(color: AppColors.pureWhite),
                    ),

                    const SizedBox(height: 20),

                    // ➕ Button
                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        setState(() {
                          isUploading = true;
                        });

                        try {
                          await onPressed();
                        } finally {
                          if (context.mounted) {
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
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
                      child: Text(
                        "Add Category",
                        style: const TextStyle(
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
    },
  );
}
