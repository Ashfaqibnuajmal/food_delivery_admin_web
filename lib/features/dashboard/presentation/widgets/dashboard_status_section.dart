import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/dashboard/controller/dashboard_controller.dart';

class DashboardStatusSection extends StatelessWidget {
  final DashboardController controller;

  const DashboardStatusSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: controller.getOrderStatusCounts(), // ← from controller, cached
      builder: (context, snapshot) {
        // ── Loading ──────────────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        // ── Error ────────────────────────────────────────────
        if (snapshot.hasError) {
          return SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'Failed to load order status',
                style: CustomTextStyles.smallWhiteText,
              ),
            ),
          );
        }

        final counts = snapshot.data!;

        final statuses = [
          _StatusItem('Making', counts['Making'] ?? 0, AppColors.lightBlue),
          _StatusItem(
            'Packing',
            counts['Packing'] ?? 0,
            AppColors.lightBlue.withOpacity(0.85),
          ),
          _StatusItem(
            'Out for Delivery',
            counts['Out for Delivery'] ?? 0,
            AppColors.lightBlue.withOpacity(0.7),
          ),
          _StatusItem(
            'Delivered',
            counts['Delivered'] ?? 0,
            AppColors.lightBlue.withOpacity(0.55),
          ),
        ];

        final total = statuses.fold<int>(0, (sum, e) => sum + e.count);
        final deliveredCount = counts['Delivered'] ?? 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─────────────────────────────────────────────────
            // STATUS ROWS
            // ─────────────────────────────────────────────────
            ...statuses.map((e) {
              final progress = total > 0 ? e.count / total : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: e.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.label,
                            style: TextStyle(
                              color: AppColors.pureWhite.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          "${e.count}",
                          style: TextStyle(
                            color: e.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.pureWhite.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(e.color),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // ─────────────────────────────────────────────────
            // TOTAL DELIVERED FOOTER
            // ─────────────────────────────────────────────────
            Divider(color: AppColors.lightBlue.withOpacity(0.12), height: 20),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.lightBlue.withOpacity(0.55),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text("Total Delivered", style: CustomTextStyles.lightWhite),
                  ],
                ),
                Text(
                  "$deliveredCount Orders",
                  style: CustomTextStyles.mediumWhiteText,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatusItem {
  final String label;
  final int count;
  final Color color;

  const _StatusItem(this.label, this.count, this.color);
}
