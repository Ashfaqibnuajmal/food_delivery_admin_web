// Summary Card Widget
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Icon icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: CustomTextStyles.header.copyWith(
                    color: AppColors.pureWhite.withOpacity(0.75),
                  ),
                ),

                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconTheme(
                    data: const IconThemeData(
                      color: AppColors.darkBlue,
                      size: 18,
                    ),
                    child: icon,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              "₹${amount.toStringAsFixed(2)}",
              style: CustomTextStyles.header.copyWith(
                color: AppColors.pureWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
