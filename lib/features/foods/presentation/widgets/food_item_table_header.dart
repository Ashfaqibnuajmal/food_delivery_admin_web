import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/header_cell.dart';

class FoodTableHeader extends StatelessWidget {
  const FoodTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          HeaderCell("Image", flex: 2),
          HeaderCell("Name\n&\nPrepTime\n&\nCalories", flex: 3),
          HeaderCell("Price", flex: 2),
          HeaderCell("Category", flex: 2),
          HeaderCell("Food Type", flex: 2),
          HeaderCell("Today Offer", flex: 2),
          HeaderCell("Half Portion\n&\nPrice", flex: 3),
          HeaderCell("Best Seller", flex: 2),
          HeaderCell("Edit", flex: 2),
          HeaderCell("Delete", flex: 2),
        ],
      ),
    );
  }
}
