import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/expances/data/models/expense_model.dart';
import 'package:user_app/features/expances/provider/expense_provider.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_edit_dialog.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_row.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_table_header.dart';

class ExpenseTable extends StatelessWidget {
  const ExpenseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final expenses = provider.expenses;

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        border: Border.all(color: AppColors.deepBlue, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const ExpenseTableHeader(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: expenses.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.white.withOpacity(0.05)),
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return ExpenseRow(
                  expense: expense,
                  onEdit: () {
                    showEditExpenseDialog(
                      context: context,
                      currentDate: expense.date,
                      currentCategory: expense.category,
                      currentAmount: expense.amount,
                      currentStatus: expense.status,
                      onSave:
                          (newDate, newCategory, newAmount, newStatus) async {
                            final updated = ExpenseModel(
                              id: expense.id!,
                              date: newDate,
                              category: newCategory,
                              amount: newAmount,
                              status: newStatus,
                            );

                            try {
                              await provider.updateExpense(updated);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Expense updated"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    );
                  },
                  onDelete: () {
                    customDeleteDialog(context, () async {
                      try {
                        await provider.deleteExpense(expense.id!);

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Deleted successfully")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
