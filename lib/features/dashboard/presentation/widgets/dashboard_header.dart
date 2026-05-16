import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/data/enum/month_name.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isMobile = MediaQuery.of(context).size.width < 700;

    final greeting = now.hour < 12
        ? "Good Morning"
        : now.hour < 17
        ? "Good Afternoon"
        : "Good Evening";

    final dateWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.darkBlue,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${now.day} ${MonthName.fromMonthNumber(now.month)} ${now.year}",
            style: CustomTextStyles.mediumWhiteText,
          ),
        ],
      ),
    );

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting, style: CustomTextStyles.mediumWhiteText),
                  const SizedBox(height: 2),
                  const Text("Dashboard", style: CustomTextStyles.loginHeading),
                ],
              ),

              const SizedBox(height: 16),

              dateWidget,
            ],
          )
        : Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting, style: CustomTextStyles.mediumWhiteText),
                  const SizedBox(height: 2),
                  const Text("Dashboard", style: CustomTextStyles.loginHeading),
                ],
              ),

              const Spacer(),

              dateWidget,
            ],
          );
  }
}
