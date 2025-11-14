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
import 'package:user_app/features/foods/data/model/food_item_model.dart';
import 'package:user_app/features/foods/provider/dialogstateprovider.dart';

Future<void> customEditFoodItemDialog({
  required BuildContext context,
  required FoodItemModel food,
  required void Function({
    required Uint8List? imageBytes,
    required String? imageUrl,
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
  onUpdate,
}) async {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController(
    text: food.name,
  );
  final TextEditingController prepController = TextEditingController(
    text: food.prepTimeMinutes.toString(),
  );
  final TextEditingController calController = TextEditingController(
    text: food.calories.toString(),
  );
  final TextEditingController descController = TextEditingController(
    text: food.description,
  );
  final TextEditingController priceController = TextEditingController(
    text: food.price.toString(),
  );
  final TextEditingController halfPriceController = TextEditingController(
    text: food.halfPrice?.toString() ?? "",
  );

  await showDialog(
    context: context,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (_) => AddFoodDialogProvider()
          ..selectedCategory = food.category
          ..isCompo = food.isCompo
          ..isTodayOffer = food.isTodayOffer
          ..isHalfAvailable = food.isHalfAvailable
          ..isBestSeller = food.isBestSeller,
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
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Picker
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
                              : Image.network(
                                  food.imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) =>
                                      progress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.lightBlue,
                                          ),
                                        ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // NAME
                      _field(
                        "Food name",
                        nameController,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Name required"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // PREP TIME
                      _field(
                        "Preparation time (min)",
                        prepController,
                        keyboard: TextInputType.number,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),

                      // CALORIES
                      _field(
                        "Calories (kcal)",
                        calController,
                        keyboard: TextInputType.number,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),

                      // DESCRIPTION
                      _field("Description", descController, maxLines: 2),
                      const SizedBox(height: 16),

                      // PRICE
                      _field(
                        "Price",
                        priceController,
                        keyboard: TextInputType.number,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),

                      // CATEGORY DROPDOWN
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Category")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.lightBlue,
                              ),
                            );
                          }

                          final categories = snapshot.data!.docs
                              .map((e) => e['name'].toString())
                              .toList();

                          return DropdownButtonFormField<String>(
                            value: dialogProvider.selectedCategory,
                            decoration: inputDecoration("Select category name"),
                            dropdownColor: AppColors.darkBlue,
                            style: CustomTextStyles.text,
                            items: categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: CustomTextStyles.text,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: dialogProvider.selectCategory,
                            validator: (v) =>
                                v == null ? "Category required" : null,
                          );
                        },
                      ),
                      const SizedBox(height: 25),

                      // Checkboxes
                      Wrap(
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
                            onChanged: (v) =>
                                dialogProvider.toggleHalfAvailable(v ?? false),
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
                          validator: (v) =>
                              dialogProvider.isHalfAvailable &&
                                  (v == null || v.trim().isEmpty)
                              ? "Half price required"
                              : null,
                        ),
                      ],

                      const SizedBox(height: 30),

                      // UPDATE BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 300,
                          ),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          onUpdate(
                            imageBytes: imageProvider.pickedImage,
                            imageUrl: food.imageUrl,
                            name: nameController.text.trim(),
                            prepTimeMinutes:
                                int.tryParse(prepController.text.trim()) ?? 0,
                            calories:
                                double.tryParse(calController.text.trim()) ??
                                0.0,
                            description: descController.text.trim(),
                            price:
                                double.tryParse(priceController.text.trim()) ??
                                0.0,
                            category: dialogProvider.selectedCategory!,
                            isCompo: dialogProvider.isCompo,
                            isTodayOffer: dialogProvider.isTodayOffer,
                            isHalfAvailable: dialogProvider.isHalfAvailable,
                            halfPrice: dialogProvider.isHalfAvailable
                                ? double.tryParse(
                                        halfPriceController.text.trim(),
                                      ) ??
                                      0.0
                                : null,
                            isBestSeller: dialogProvider.isBestSeller,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Update Food Item",
                          style: CustomTextStyles.buttonText,
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
}

//────────────────────────────────────────────
// 🔹 FIELD WIDGET → NOW SUPPORTS VALIDATOR
//────────────────────────────────────────────
Widget _field(
  String hint,
  TextEditingController ctl, {
  TextInputType keyboard = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: ctl,
    keyboardType: keyboard,
    maxLines: maxLines,
    decoration: inputDecoration(hint),
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
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.lightBlue,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: CustomTextStyles.text)),
        ],
      ),
    ),
  );
}
