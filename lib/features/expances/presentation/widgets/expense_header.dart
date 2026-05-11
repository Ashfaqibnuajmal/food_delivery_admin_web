import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class ExpenseHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddPressed;

  const ExpenseHeader({
    super.key,
    required this.title,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Text(title, style: CustomTextStyles.loginHeading),

        // Add Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: onAddPressed,
          child: const Text("Add Expense", style: CustomTextStyles.buttonText),
        ),
      ],
    );
  }
}
