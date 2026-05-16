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
    final isMobile = MediaQuery.of(context).size.width < 700;

    final trendColor = trendUp ? AppColors.green : AppColors.errorRed;

    return Container(
      height: isMobile ? 120 : 130,
      padding: EdgeInsets.all(isMobile ? 12 : 14),
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
                  style: CustomTextStyles.smallWhiteText.copyWith(
                    fontSize: isMobile ? 11 : null,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: EdgeInsets.all(isMobile ? 7 : 8),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.darkBlue,
                  size: isMobile ? 15 : 16,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 10 : 14),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.nameStyle.copyWith(
              fontSize: isMobile ? 20 : null,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 6 : 8,
                  vertical: 4,
                ),
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
                        size: isMobile ? 11 : 12,
                      ),

                      const SizedBox(width: 4),
                    ],

                    Text(
                      trend,
                      style: TextStyle(
                        color: trendColor,
                        fontSize: isMobile ? 9 : 10,
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
                  style: CustomTextStyles.smallWhiteText.copyWith(
                    fontSize: isMobile ? 10 : null,
                  ),
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
  const StatsLoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return isMobile
        ? Column(
            children: const [
              Row(
                children: [
                  Expanded(child: StatLoadingCard()),
                  SizedBox(width: 12),
                  Expanded(child: StatLoadingCard()),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: StatLoadingCard()),
                  SizedBox(width: 12),
                  Expanded(child: StatLoadingCard()),
                ],
              ),
            ],
          )
        : Row(
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
  const StatLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      height: isMobile ? 120 : 130,
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
