import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/controller/dashboard_controller.dart';
import 'package:user_app/features/dashboard/presentation/widgets/dashboard_status_section.dart';
import 'package:user_app/features/dashboard/presentation/widgets/revenue_chart.dart';
import 'package:user_app/features/dashboard/presentation/widgets/section_card.dart';
import 'package:user_app/features/dashboard/presentation/widgets/stat_card_row.dart';
import 'package:user_app/features/dashboard/presentation/widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController();
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),

              SizedBox(height: 24),

              StatCardsRow(),

              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SectionCard(
                      title: 'Revenue',
                      icon: Icons.bar_chart,
                      height: 330,
                      child: RevenueChart(controller: controller),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    flex: 2,
                    child: SectionCard(
                      title: 'Orders',
                      icon: Icons.receipt,
                      height: 330,
                      child: DashboardStatusSection(controller: controller),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
