import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/network_image_placeolder.dart';
import 'package:user_app/features/foods/logic/controller/food_controller.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';

class FoodItemTableRow extends StatelessWidget {
  final FoodItemModel food;

  const FoodItemTableRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final calories = food.calories % 1 == 0
        ? food.calories.toStringAsFixed(0)
        : food.calories.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: AppColors.lightBlue.withOpacity(0.08)),
      child: Row(
        children: [
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
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "${food.name}\n${food.prepTimeMinutes} min | $calories kcal",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "₹ ${food.price.toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.category,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isCompo ? "Combo" : "Individual",
                textAlign: TextAlign.center,
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isTodayOffer ? "Offer" : "No Offer",
                textAlign: TextAlign.center,
                style: CustomTextStyles.userStatus(food.isTodayOffer),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                food.isHalfAvailable
                    ? "Available\n₹ ${food.halfPrice?.toStringAsFixed(2) ?? '-'}"
                    : "Not Available",
                textAlign: TextAlign.center,
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isBestSeller ? "★ Yes" : "No",
                textAlign: TextAlign.center,
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
