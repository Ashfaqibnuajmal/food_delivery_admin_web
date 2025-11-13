import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_action.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_header.dart';
import 'package:user_app/features/expances/presentation/widgets/expance_table.dart';
import 'package:user_app/features/expances/presentation/widgets/summary_section.dart';

class ExpanceScreen extends StatelessWidget {
  const ExpanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpanceHeader(
                title: "Expanse Management",
                onAddPressed: () {
                  showAddExpense(context);
                },
              ),
              const SizedBox(height: 40),
              const ExpanceSummarySection(),
              const SizedBox(height: 30),
              const Expanded(child: ExpanceTable()),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
