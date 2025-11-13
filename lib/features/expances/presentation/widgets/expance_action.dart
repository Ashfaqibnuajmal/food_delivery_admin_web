import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/features/expances/data/services/expance_services.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_add_dilog.dart';
import 'package:user_app/features/expances/provider/expance_provider.dart';

final expenseService =
    ExpanceServices(); // You can make it singleton or pass if needed

void showAddExpense(BuildContext context) {
  final provider = Provider.of<ExpenseProvider>(context, listen: false);

  customAddExpenseDialog(
    context: context,
    onPressed: () {
      if (provider.date != null &&
          provider.category != null &&
          provider.amount != null &&
          provider.status != null) {
        expenseService.addExpance(
          date: provider.date!,
          category: provider.category!,
          amount: provider.amount!.toDouble(),
          status: provider.status!,
        );

        provider.clearDate();
        provider.clearCategory();
        provider.clearAmount();
        provider.clearStatus();
      }
    },
  );
}
