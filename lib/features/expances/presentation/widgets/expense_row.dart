import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/data/models/expense_model.dart';

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
      color: AppColors.lightBlue.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          // DATE
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                DateFormat('dd MMM yyyy').format(expense.date),
                style: CustomTextStyles.text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // CATEGORY
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                expense.category,
                style: CustomTextStyles.text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // AMOUNT
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "₹${expense.amount.toStringAsFixed(2)}",
                style: CustomTextStyles.addCategory,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // STATUS
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                expense.status,
                style: CustomTextStyles.status(expense.status),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // EDIT
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),

          // DELETE
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
