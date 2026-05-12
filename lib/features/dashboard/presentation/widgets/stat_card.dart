import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String trend;
  final bool trendUp;
  final String? footerText;
  final bool showTrendIcon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendUp,
    this.footerText,
    this.showTrendIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = trendUp ? AppColors.green : AppColors.errorRed;

    return Container(
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.smallWhiteText,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.darkBlue, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.nameStyle,
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showTrendIcon) ...[
                      Icon(
                        trendUp
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: trendColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      trend,
                      style: TextStyle(
                        color: trendColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  footerText ?? "vs yesterday",
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.smallWhiteText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsLoadingRow extends StatelessWidget {
  const StatsLoadingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: StatLoadingCard()),
        SizedBox(width: 12),
        Expanded(child: StatLoadingCard()),
        SizedBox(width: 12),
        Expanded(child: StatLoadingCard()),
        SizedBox(width: 12),
        Expanded(child: StatLoadingCard()),
      ],
    );
  }
}

class StatLoadingCard extends StatelessWidget {
  const StatLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
