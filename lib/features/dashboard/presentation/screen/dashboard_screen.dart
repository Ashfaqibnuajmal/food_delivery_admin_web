import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/presentation/widgets/dashboard_section.dart';
import 'package:user_app/features/dashboard/presentation/widgets/stat_card_row.dart';
import 'package:user_app/features/dashboard/presentation/widgets/topbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TopBar(),

              SizedBox(height: 24),

              StatCardsRow(),

              SizedBox(height: 20),

              DashboardSection(),
            ],
          ),
        ),
      ),
    );
  }
}
