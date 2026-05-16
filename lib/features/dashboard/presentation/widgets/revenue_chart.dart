import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/controller/dashboard_controller.dart';
import 'package:user_app/features/dashboard/data/models/dashboard_models.dart';

class RevenueChart extends StatelessWidget {
  final DashboardController controller;

  const RevenueChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return FutureBuilder<(List<DailyRevenue>, double)>(
      future: controller.getRevenueData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Failed to load revenue',
                style: TextStyle(color: AppColors.pureWhite.withOpacity(0.5)),
              ),
            ),
          );
        }

        final data = snapshot.data!.$1;
        final monthlyTotal = snapshot.data!.$2;

        final maxAmount = controller.getMaxAmount(data);
        final weekTotal = controller.getWeekTotal(data);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            isMobile
                ? Column(
                    children: [
                      _OverviewCard(
                        icon: Icons.calendar_view_week_rounded,
                        label: "Week Sales",
                        value: "₹${weekTotal.toStringAsFixed(0)}",
                      ),

                      const SizedBox(height: 10),

                      _OverviewCard(
                        icon: Icons.calendar_month_rounded,
                        label: "Month Sales",
                        value: "₹${monthlyTotal.toStringAsFixed(0)}",
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _OverviewCard(
                        icon: Icons.calendar_view_week_rounded,
                        label: "Week Sales",
                        value: "₹${weekTotal.toStringAsFixed(0)}",
                      ),

                      const SizedBox(width: 10),

                      _OverviewCard(
                        icon: Icons.calendar_month_rounded,
                        label: "Month Sales",
                        value: "₹${monthlyTotal.toStringAsFixed(0)}",
                      ),
                    ],
                  ),

            const SizedBox(height: 20),

            SizedBox(
              height: 130,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final isToday = controller.isToday(item.date);

                  final barHeight = controller.getBarHeight(
                    item.totalAmount,
                    maxAmount,
                  );

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.totalAmount > 0)
                            Text(
                              "₹${item.totalAmount.toInt()}",
                              style: TextStyle(
                                color: AppColors.pureWhite.withOpacity(
                                  isToday ? 0.9 : 0.4,
                                ),
                                fontSize: isMobile ? 8 : 9,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          else
                            const SizedBox(height: 11),

                          const SizedBox(height: 4),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            height: barHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.lightBlue.withOpacity(
                                    isToday ? 1.0 : 0.75,
                                  ),
                                  AppColors.lightBlue.withOpacity(0.15),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            item.day,
                            style: TextStyle(
                              color: AppColors.pureWhite.withOpacity(
                                isToday ? 1.0 : 0.45,
                              ),
                              fontSize: isMobile ? 9 : 10,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.pureWhite.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.lightBlue, size: 18),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: CustomTextStyles.smallWhiteText),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    style: CustomTextStyles.bigWhiteText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
