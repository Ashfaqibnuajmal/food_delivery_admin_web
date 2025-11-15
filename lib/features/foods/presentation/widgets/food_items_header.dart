import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/foods/controller/food_controller.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';

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
          onPressed: () {
            FoodController.showAddFoodDialog(
              context: context,
              foodServices: foodServices,
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
