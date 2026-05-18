import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_action.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_header.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_table.dart';
import 'package:user_app/features/expances/presentation/widgets/expense_summary_section.dart';
import 'package:user_app/features/expances/provider/expense_provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();

    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    provider.listenToExpenses(); // 🔥 ONLY ONCE
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseHeader(
                title: "Expense Management",
                onAddPressed: () {
                  showAddExpense(context);
                },
              ),
              const SizedBox(height: 40),
              const ExpenseSummarySection(),
              const SizedBox(height: 30),
              const Expanded(child: ExpenseTable()),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
