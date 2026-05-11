import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/presentation/widgets/summary_card.dart';
import 'package:user_app/features/expances/presentation/provider/expense_provider.dart';

class ExpenseSummarySection extends StatelessWidget {
  const ExpenseSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final expenses = provider.expenses;

    // ✅ Optional loading / empty state
    if (expenses.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(color: Colors.white)),
      );
    }

    double gasTotal = 0;
    double rentTotal = 0;
    double electricityTotal = 0;
    double stationaryTotal = 0;

    for (var exp in expenses) {
      double value = exp.signedAmount;

      switch (exp.category) {
        case "Gas":
          gasTotal += value;
          break;
        case "Room Rent":
          rentTotal += value;
          break;
        case "Electricity":
          electricityTotal += value;
          break;
        case "Stationary":
          stationaryTotal += value;
          break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SummaryCard(
          title: "Gas",
          amount: gasTotal,
          icon: const Icon(Icons.gas_meter, color: AppColors.pureWhite),
        ),
        SummaryCard(
          title: "Room Rent",
          amount: rentTotal,
          icon: const Icon(Icons.home, color: AppColors.pureWhite),
        ),
        SummaryCard(
          title: "Electricity",
          amount: electricityTotal,
          icon: const Icon(
            Icons.electric_bolt_outlined,
            color: AppColors.pureWhite,
          ),
        ),
        SummaryCard(
          title: "Stationary",
          amount: stationaryTotal,
          icon: const Icon(Icons.shopping_cart, color: AppColors.pureWhite),
        ),
      ],
    );
  }
}
