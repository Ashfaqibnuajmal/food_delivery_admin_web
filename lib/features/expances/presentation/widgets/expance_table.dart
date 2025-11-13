import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/confiorm_dilog.dart';
import 'package:user_app/features/expances/data/models/expance_model.dart';
import 'package:user_app/features/expances/data/services/expance_services.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_edit_dilog.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_row.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_table_header.dart';

class ExpanceTable extends StatelessWidget {
  final List<ExpenseModel>? expenses;

  const ExpanceTable({super.key, this.expenses});

  @override
  Widget build(BuildContext context) {
    final expenseService = ExpanceServices();

    return StreamBuilder<List<ExpenseModel>>(
      stream: expenseService.fetchExpenses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.pureWhite),
          );
        }

        final expenses = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.1),
            border: Border.all(color: AppColors.deepBlue, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              const ExpanceTableHeader(),

              // Body
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
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
                          onSave: (newDate, newCategory, newAmount, newStatus) {
                            final updated = ExpenseModel(
                              expanseUid: expense.expanseUid,
                              date: newDate,
                              category: newCategory,
                              amount: newAmount,
                              status: newStatus,
                            );
                            expenseService.editExpanse(updated);
                          },
                        );
                      },
                      onDelete: () {
                        customDeleteDialog(context, () async {
                          await expenseService.deleteExpense(
                            expense.expanseUid,
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
