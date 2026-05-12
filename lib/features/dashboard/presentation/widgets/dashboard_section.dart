import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          flex: 3,
          child: _SectionCard(
            title: "Revenue Overview",
            icon: Icons.bar_chart_rounded,
            height: 300,
            child: _RevenueChart(),
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: _SectionCard(
            title: "Order Status",
            icon: Icons.donut_large_rounded,
            height: 300,
            child: _OrderStatusSection(),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final double height;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lightBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          Divider(color: AppColors.lightBlue.withOpacity(0.12), height: 24),

          Expanded(child: child),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  @override
  Widget build(BuildContext context) {
    final data = [180, 320, 240, 410, 290, 480, 370];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (i) {
        final value = data[i];
        final height = value / 3;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "₹$value",
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.lightBlue,
                        AppColors.lightBlue.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  days[i],
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// ORDER STATUS
// ─────────────────────────────────────────────

class _OrderStatusSection extends StatelessWidget {
  const _OrderStatusSection();

  @override
  Widget build(BuildContext context) {
    final statuses = [
      _StatusItem("Making", 14, AppColors.lightBlue),

      _StatusItem("Packing", 8, AppColors.lightBlue.withOpacity(0.85)),

      _StatusItem("Delivery", 9, AppColors.lightBlue.withOpacity(0.7)),

      _StatusItem("Delivered", 37, AppColors.lightBlue.withOpacity(0.55)),
    ];

    final total = statuses.fold<int>(0, (sum, e) => sum + e.count);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: statuses.map((e) {
        final progress = e.count / total;

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

              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.pureWhite.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(e.color),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatusItem {
  final String label;
  final int count;
  final Color color;

  const _StatusItem(this.label, this.count, this.color);
}
