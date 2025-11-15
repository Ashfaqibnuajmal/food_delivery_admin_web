import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/presentation/widgets/food_item_add_dilog.dart';

class FoodController {
  /// Handles opening the add-food dialog and submitting the item
  static Future<void> showAddFoodDialog({
    required BuildContext context,
    required FoodItemServices foodServices,
  }) async {
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

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Food item added successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error adding food item: $e"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
    );
  }

  /// Show edit dialog
  static Future<void> editFood(BuildContext context, FoodItemModel food) async {
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

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Food item updated successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error updating food item: $e"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
    );
  }

  /// Show delete dialog
  static void deleteFood(BuildContext context, FoodItemModel food) {
    customDeleteDialog(context, () async {
      await context.read<FoodItemServices>().deleteFoodItem(food);
      if (context.mounted) Navigator.pop(context);
    });
  }

  static Future<void> customEditFoodItemDialog({
    required BuildContext context,
    required FoodItemModel food,
    required Future<Null> Function({
      required double calories,
      required String category,
      required String description,
      required double? halfPrice,
      required Uint8List? imageBytes,
      required String? imageUrl,
      required bool isBestSeller,
      required bool isCompo,
      required bool isHalfAvailable,
      required bool isTodayOffer,
      required String name,
      required int prepTimeMinutes,
      required double price,
    })
    onUpdate,
  }) async {}
}
