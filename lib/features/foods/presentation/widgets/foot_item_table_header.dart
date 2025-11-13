import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

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
          _HeaderCell("Image", flex: 2),
          _HeaderCell("Name\n&\nPrepTime\n&\nCalories", flex: 3),
          _HeaderCell("Price", flex: 2),
          _HeaderCell("Category", flex: 2),
          _HeaderCell("Food Type", flex: 2),
          _HeaderCell("Today Offer", flex: 2),
          _HeaderCell("Half Portion\n&\nPrice", flex: 3),
          _HeaderCell("Best Seller", flex: 2),
          _HeaderCell("Edit", flex: 2),
          _HeaderCell("Delete", flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: CustomTextStyles.tableHeader,
        ),
      ),
    );
  }
}
