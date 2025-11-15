import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/network_image_placeolder.dart';
import 'package:user_app/features/foods/controller/food_controller.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';

class FoodItemTableRow extends StatelessWidget {
  final FoodItemModel food;

  const FoodItemTableRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: AppColors.lightBlue.withOpacity(0.08)),
      child: Row(
        children: [
          // Image
          Expanded(
            flex: 2,
            child: Center(
              child: ShimmerNetworkImage(
                imageUrl: food.imageUrl,
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 40,
                  height: 40,
                  color: AppColors.lightGrey,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.pureWhite,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // Name & Info
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "${food.name}\n${food.prepTimeMinutes} min | ${food.calories} kcal",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          // Price
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "₹ ${food.price.toStringAsFixed(2)}",
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Center(
              child: Text(food.category, style: CustomTextStyles.text),
            ),
          ),
          // Type
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isCompo ? "Compo" : "Individual",
                style: CustomTextStyles.text,
              ),
            ),
          ),
          // Offer
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isTodayOffer ? "Offer" : "No Offer",
                style: CustomTextStyles.userStatus(food.isTodayOffer),
              ),
            ),
          ),
          // Half Available
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                food.isHalfAvailable
                    ? "Available\n₹ ${food.halfPrice?.toStringAsFixed(2) ?? '-'}"
                    : "Not Available",
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          // Best Seller
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isBestSeller ? "★ Yes" : "No",
                style: CustomTextStyles.bestSeller(food.isBestSeller),
              ),
            ),
          ),

          // Edit Button
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  foregroundColor: AppColors.pureWhite,
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => FoodController.editFood(context, food),
                child: const Text("Edit", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),

          // Delete Button
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => FoodController.deleteFood(context, food),
                child: const Text("Delete", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
