import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/features/expances/data/services/expense_service.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_add_dialog.dart';
import 'package:user_app/features/expances/provider/expense_provider.dart';

final expenseService =
    ExpenseService(); // You can make it singleton or pass if needed

void showAddExpense(BuildContext context) {
  final provider = Provider.of<ExpenseProvider>(context, listen: false);

  customAddExpenseDialog(
    context: context,
    onPressed: () {
      if (provider.date != null &&
          provider.category != null &&
          provider.amount != null &&
          provider.status != null) {
        expenseService.addExpense(
          date: provider.date!,
          category: provider.category!,
          amount: provider.amount!.toDouble(),
          status: provider.status!,
        );

        provider.clearAll();
      }
    },
  );
}
