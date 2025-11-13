import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/foods/data/model/food_item_model.dart';
import 'package:user_app/features/foods/data/services/food_item_services.dart';
import 'package:user_app/features/foods/presentation/widgets/food_item_table_row.dart';

// This is your custom widget
class FoodItemTable extends StatelessWidget {
  const FoodItemTable({super.key});

  @override
  Widget build(BuildContext context) {
    final foodServices = context.read<FoodItemServices>();

    return Expanded(
      child: StreamBuilder<List<FoodItemModel>>(
        stream: foodServices.fetchFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightBlue),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No food items found",
                style: CustomTextStyles.buttonText,
              ),
            );
          }

          return Consumer<UserSearchProvider>(
            builder: (context, searchProvider, _) {
              final query = searchProvider.query.toLowerCase();

              // Filtered list based on voice/text
              final filteredItems = snapshot.data!
                  .where((food) => food.name.toLowerCase().contains(query))
                  .toList();

              if (filteredItems.isEmpty) {
                return const Center(
                  child: Text(
                    "No food items found",
                    style: CustomTextStyles.buttonText,
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final food = filteredItems[index];
                  return FoodItemTableRow(food: food);
                },
              );
            },
          );
        },
      ),
    );
  }
}
