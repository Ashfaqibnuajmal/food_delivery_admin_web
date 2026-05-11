import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/multiple_image_provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/categories/controller/category_controller.dart';
import 'package:user_app/features/categories/presentation/provider/category_provider.dart';

custemAddDialog({
  required BuildContext context,
  required TextEditingController controller,
  required Future<void> Function() onPressed,
  List<String>? oldImages,
}) {
  final formKey = GlobalKey<FormState>();
  final categoryController = CategoryController(); // only for image picking

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // ─── Read Providers ──────────────────────────────
          final imageProvider = Provider.of<MultipleImageProvider>(context);
          final categoryProvider = context.watch<CategoryProvider>(); // 👈 new

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
                    // ─── Image Picker ────────────────────────────────
                    GestureDetector(
                      onTap: categoryProvider.isLoading
                          ? null // 👈 disable tap while uploading
                          : () async => await categoryController
                                .handleImagesPick(context),
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
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.memory(
                                          imageProvider.pickedImages[index],
                                          width: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // 👈 remove individual image
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () =>
                                              imageProvider.removeImage(index),
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

                    // ─── Name Field ──────────────────────────────────
                    TextFormField(
                      controller: controller,
                      enabled: !categoryProvider.isLoading, // 👈 from provider
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration("Category Name"),
                      validator:
                          categoryProvider.validateName, // 👈 from provider
                      style: const TextStyle(color: AppColors.pureWhite),
                    ),

                    const SizedBox(height: 20),

                    // ─── Submit Button ───────────────────────────────
                    ElevatedButton(
                      onPressed:
                          categoryProvider
                              .isLoading // 👈 from provider
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              await onPressed();
                              Navigator.pop(context);
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
                      child: categoryProvider.isLoading
                          ? const SizedBox(
                              // 👈 loading spinner while uploading
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.pureWhite,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
    },
  );
}
