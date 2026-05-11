import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class ExpenseTableHeader extends StatelessWidget {
  const ExpenseTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Date", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Category", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Amount", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Status", style: CustomTextStyles.header),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text("Edit", style: CustomTextStyles.header)),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("Delete", style: CustomTextStyles.header),
            ),
          ),
        ],
      ),
    );
  }
}
