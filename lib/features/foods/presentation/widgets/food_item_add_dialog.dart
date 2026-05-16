import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/functions/image_functions.dart';
import 'package:user_app/core/provider/pick_image.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/foods/logic/provider/dialogstateprovider.dart';

Future<void> customAddFoodItemDialog({
  required BuildContext context,
  String? oldImage,
  required Future<bool> Function({
    required Uint8List? imageBytes,
    required String name,
    required int prepTimeMinutes,
    required double calories,
    required String description,
    required double price,
    required String category,
    required bool isCompo,
    required bool isTodayOffer,
    required bool isHalfAvailable,
    required double? halfPrice,
    required bool isBestSeller,
  })
  onSubmit,
}) async {
  final formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prepController = TextEditingController();
  final TextEditingController calController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController halfPriceController = TextEditingController();

  context.read<ImageProviderModel>().clearImage();

  try {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return ChangeNotifierProvider(
          create: (_) => AddFoodDialogProvider(),
          child: Consumer2<ImageProviderModel, AddFoodDialogProvider>(
            builder: (context, imageProvider, dialogProvider, _) {
              return Dialog(
                backgroundColor: AppColors.deepBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 50,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(
                    16,
                  ).copyWith(left: 24, right: 24, bottom: 30),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 📸 image picker
                        GestureDetector(
                          onTap: () async {
                            try {
                              final image = await pickImage();
                              imageProvider.setImage(image);
                            } catch (e) {
                              log("Image pick error: $e");
                            }
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              border: Border.all(
                                color: AppColors.mediumBlue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: imageProvider.pickedImage != null
                                ? Image.memory(
                                    imageProvider.pickedImage!,
                                    fit: BoxFit.contain,
                                  )
                                : oldImage != null
                                ? Image.network(
                                    oldImage,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.lightBlue,
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      "Click here to add image!",
                                      style: CustomTextStyles.buttonText,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 📝 Inputs
                        _field(
                          "Enter food name",
                          nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter food name";
                            }
                            if (value.trim().length < 2) {
                              return "Food name must be at least 2 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _field(
                          "Preparation time (min)",
                          prepController,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            final prepTime = int.tryParse(value?.trim() ?? "");
                            if (prepTime == null) {
                              return "Enter valid preparation time";
                            }
                            if (prepTime <= 0) {
                              return "Preparation time must be greater than 0";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _field(
                          "Calories (kcal)",
                          calController,
                          validator: (value) {
                            final calories = double.tryParse(
                              value?.trim() ?? "",
                            );
                            if (calories == null) {
                              return "Enter valid calories";
                            }
                            if (calories < 0) {
                              return "Calories cannot be negative";
                            }
                            return null;
                          },
                          keyboard: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _field(
                          "Description",
                          descController,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _field(
                          "Price",
                          priceController,
                          validator: (value) {
                            final price = double.tryParse(value?.trim() ?? "");
                            if (price == null) {
                              return "Enter valid price";
                            }
                            if (price <= 0) {
                              return "Price must be greater than 0";
                            }
                            return null;
                          },
                          keyboard: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // 📂 Category dropdown
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Category")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.lightBlue,
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return const Text(
                                "Something went wrong while loading categories.",
                                style: CustomTextStyles.text,
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text(
                                "No categories found.",
                                style: CustomTextStyles.text,
                              );
                            }

                            final categories = snapshot.data!.docs
                                .map((e) => e["name"].toString())
                                .where((name) => name.trim().isNotEmpty)
                                .toList();

                            return DropdownButtonFormField<String>(
                              initialValue: dialogProvider.selectedCategory,
                              isExpanded: true,
                              decoration: inputDecoration(""),
                              dropdownColor: AppColors.darkBlue,
                              style: CustomTextStyles.text.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              hint: const Text(
                                "Select a category",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              iconEnabledColor: Colors.white70,
                              items: categories
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Center(
                                        child: Text(
                                          e,
                                          style: CustomTextStyles.text,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Select category";
                                }
                                return null;
                              },
                              onChanged: (val) =>
                                  dialogProvider.selectCategory(val),
                              selectedItemBuilder: (context) {
                                return categories
                                    .map(
                                      (e) => Center(
                                        child: Text(
                                          e,
                                          style: CustomTextStyles.text,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                    .toList();
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 25),

                        // ✅ checkboxes
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 12,
                          spacing: 12,
                          children: [
                            _checkBoxItem(
                              label: "Compo Food",
                              value: dialogProvider.isCompo,
                              onChanged: (v) =>
                                  dialogProvider.toggleCompo(v ?? false),
                            ),
                            _checkBoxItem(
                              label: "Today Offer",
                              value: dialogProvider.isTodayOffer,
                              onChanged: (v) =>
                                  dialogProvider.toggleTodayOffer(v ?? false),
                            ),
                            _checkBoxItem(
                              label: "Half Available",
                              value: dialogProvider.isHalfAvailable,
                              onChanged: (v) => dialogProvider
                                  .toggleHalfAvailable(v ?? false),
                            ),
                            _checkBoxItem(
                              label: "Best Seller",
                              value: dialogProvider.isBestSeller,
                              onChanged: (v) =>
                                  dialogProvider.toggleBestSeller(v ?? false),
                            ),
                          ],
                        ),

                        if (dialogProvider.isHalfAvailable) ...[
                          const SizedBox(height: 16),
                          _field(
                            "Half Price",
                            halfPriceController,
                            keyboard: TextInputType.number,
                            validator: (value) {
                              if (!dialogProvider.isHalfAvailable) return null;

                              final fullPrice =
                                  double.tryParse(
                                    priceController.text.trim(),
                                  ) ??
                                  0.0;
                              final halfPrice = double.tryParse(
                                value?.trim() ?? "",
                              );

                              if (halfPrice == null) {
                                return "Enter valid half price";
                              }

                              if (halfPrice <= 0) {
                                return "Half price must be greater than 0";
                              }

                              if (halfPrice >= fullPrice) {
                                return "Half price must be less than full price";
                              }

                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 30),

                        // 🎯 Add Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightBlue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 300,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: dialogProvider.isSubmitting
                                ? null
                                : () async {
                                    if (!formkey.currentState!.validate()) {
                                      return;
                                    }

                                    if (imageProvider.pickedImage == null &&
                                        oldImage == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please select an image!",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    dialogProvider.setSubmitting(true);

                                    final success = await onSubmit(
                                      imageBytes: imageProvider.pickedImage,
                                      name: nameController.text.trim(),
                                      prepTimeMinutes:
                                          int.tryParse(
                                            prepController.text.trim(),
                                          ) ??
                                          0,
                                      calories:
                                          double.tryParse(
                                            calController.text.trim(),
                                          ) ??
                                          0.0,
                                      description: descController.text.trim(),
                                      price:
                                          double.tryParse(
                                            priceController.text.trim(),
                                          ) ??
                                          0.0,
                                      category:
                                          dialogProvider.selectedCategory!,
                                      isCompo: dialogProvider.isCompo,
                                      isTodayOffer: dialogProvider.isTodayOffer,
                                      isHalfAvailable:
                                          dialogProvider.isHalfAvailable,
                                      halfPrice: dialogProvider.isHalfAvailable
                                          ? double.tryParse(
                                                  halfPriceController.text
                                                      .trim(),
                                                ) ??
                                                0.0
                                          : null,
                                      isBestSeller: dialogProvider.isBestSeller,
                                    );

                                    if (success && dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                      return;
                                    }

                                    if (context.mounted) {
                                      dialogProvider.setSubmitting(false);
                                    }
                                  },
                            child: dialogProvider.isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.pureWhite,
                                    ),
                                  )
                                : const Text(
                                    "Add Food Item",
                                    style: CustomTextStyles.buttonText,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  } finally {
    nameController.dispose();
    prepController.dispose();
    calController.dispose();
    descController.dispose();
    priceController.dispose();
    halfPriceController.dispose();
  }
}

Widget _field(
  String label,
  TextEditingController ctl, {
  TextInputType keyboard = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: ctl,
    keyboardType: keyboard,
    maxLines: maxLines,
    decoration: inputDecoration(label),
    style: CustomTextStyles.text,
    validator: validator,
  );
}

Widget _checkBoxItem({
  required String label,
  required bool value,
  required ValueChanged<bool?> onChanged,
}) {
  return InkWell(
    onTap: () => onChanged(!value),
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? AppColors.lightBlue : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.lightBlue.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(color: Colors.white54, width: 1.5),
              activeColor: AppColors.lightBlue,
              checkColor: AppColors.pureWhite,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: CustomTextStyles.text.copyWith(
                color: AppColors.pureWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
