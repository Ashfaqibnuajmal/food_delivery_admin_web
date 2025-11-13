import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/presentation/widgets/food_item_add_dilog.dart';

class FoodItemsHeader extends StatelessWidget {
  final FoodItemServices foodServices;
  const FoodItemsHeader({super.key, required this.foodServices});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Food Management", style: CustomTextStyles.loginHeading),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await customAddFoodItemDialog(
              context: context,
              onSubmit:
                  ({
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
                  }) async {
                    try {
                      await foodServices.addFoodItem(
                        FoodItemModel(
                          name: name,
                          prepTimeMinutes: prepTimeMinutes,
                          calories: calories,
                          description: description,
                          price: price,
                          category: category,
                          isCompo: isCompo,
                          isTodayOffer: isTodayOffer,
                          isHalfAvailable: isHalfAvailable,
                          halfPrice: halfPrice,
                          isBestSeller: isBestSeller,
                          imageUrl: '',
                          foodItemId: '',
                        ),
                        imageBytes!,
                      );

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Food item added successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error adding food item: $e"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
            );
          },
          child: const Text(
            "Add Food Items",
            style: CustomTextStyles.buttonText,
          ),
        ),
      ],
    );
  }
}
