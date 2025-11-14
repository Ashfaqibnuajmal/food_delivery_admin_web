import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/core/widgets/network_image_placeolder.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/presentation/widgets/food_item_edit_dilog.dart';

// ignore: unused_element
class FoodItemTableRow extends StatelessWidget {
  final FoodItemModel food;
  const FoodItemTableRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      // ignore: deprecated_member_use
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
                "${food.name}\n${food.prepTimeMinutes} min | ${food.calories} kcal",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "₹ ${food.price.toStringAsFixed(2)}",
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                food.category,
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isCompo ? "Compo" : "Individual",
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isTodayOffer ? "Offer" : "No Offer",
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
                style: CustomTextStyles.buttonText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isBestSeller ? "★ Yes" : "No",
                style: CustomTextStyles.bestSeller(food.isBestSeller),
              ),
            ),
          ),

          // ✏️ Edit Button
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
                onPressed: () async {
                  await customEditFoodItemDialog(
                    context: context,
                    food: food,
                    onUpdate:
                        ({
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
                        }) async {
                          final foodServices = context.read<FoodItemServices>();
                          try {
                            await foodServices.editFoodItem(
                              food.copyWith(
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
                              ),
                              newImageBytes: imageBytes,
                              oldImageUrl: food.imageUrl,
                            );

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Food item updated successfully!",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error updating food item: $e"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                  );
                },
                child: const Text("Edit", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),

          // 🗑 Delete Button
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
                onPressed: () {
                  customDeleteDialog(context, () async {
                    await context.read<FoodItemServices>().deleteFoodItem(food);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  });
                },
                child: const Text("Delete", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
