import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class ExpanceTableHeader extends StatelessWidget {
  const ExpanceTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Center(child: Text("Date", style: CustomTextStyles.header)),
          ),
          Expanded(
            child: Center(
              child: Text("Category", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            child: Center(
              child: Text("Amount", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            child: Center(
              child: Text("Status", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            child: Center(child: Text("Edit", style: CustomTextStyles.header)),
          ),
          Expanded(
            child: Center(
              child: Text("Delete", style: CustomTextStyles.header),
            ),
          ),
        ],
      ),
    );
  }
}
