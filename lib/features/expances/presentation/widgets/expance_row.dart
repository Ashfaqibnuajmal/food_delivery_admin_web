import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/data/models/expance_model.dart';

class ExpenseRow extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseRow({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlue.withOpacity(0.1), // row background color
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                expense.date.toString().split(" ")[0],
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(expense.category, style: CustomTextStyles.text),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                expense.amount.toString(),
                style: CustomTextStyles.addCategory,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                expense.status,
                style: CustomTextStyles.status(expense.status),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                ),
                onPressed: onEdit,
                child: const Text("Edit", style: CustomTextStyles.text),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: onDelete,
                child: const Text("Delete", style: CustomTextStyles.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
