import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/data/models/daily_revenue.dart';
import 'package:user_app/features/dashboard/data/services/revenue_service.dart';

class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  final _service = RevenueService();

  // fetch both at the same time
  late Future<(List<DailyRevenue>, double)> _future;

  @override
  void initState() {
    super.initState();
    _future =
        Future.wait([
          _service.getWeeklyRevenue(),
          _service.getMonthlyTotal(),
        ]).then(
          (results) => (results[0] as List<DailyRevenue>, results[1] as double),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(List<DailyRevenue>, double)>(
      future: _future,
      builder: (context, snapshot) {
        // ── Loading ──────────────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        // ── Error ────────────────────────────────────────────
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

        final maxAmount = data.isEmpty
            ? 1.0
            : data.map((e) => e.totalAmount).reduce((a, b) => a > b ? a : b);

        final weekTotal = data.fold(0.0, (sum, e) => sum + e.totalAmount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────
            // OVERVIEW CARDS — Week & Month
            // ─────────────────────────────────────────────────
            Row(
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

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // BAR CHART
            // ─────────────────────────────────────────────────
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final isToday =
                      item.date.day == DateTime.now().day &&
                      item.date.month == DateTime.now().month;

                  final barHeight = maxAmount > 0
                      ? ((item.totalAmount / maxAmount) * 120).clamp(
                          item.totalAmount > 0 ? 6.0 : 4.0,
                          120.0,
                        )
                      : 4.0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (item.totalAmount > 0)
                            Text(
                              "₹${item.totalAmount.toInt()}",
                              style: TextStyle(
                                color: AppColors.pureWhite.withOpacity(
                                  isToday ? 0.9 : 0.4,
                                ),
                                fontSize: 9,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          const SizedBox(height: 6),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            height: barHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
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

                          const SizedBox(height: 8),

                          Text(
                            item.day,
                            style: TextStyle(
                              color: AppColors.pureWhite.withOpacity(
                                isToday ? 1.0 : 0.45,
                              ),
                              fontSize: 11,
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

// ─────────────────────────────────────────────────────────────
// OVERVIEW STAT CARD
// ─────────────────────────────────────────────────────────────
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
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.pureWhite.withOpacity(0.45),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
