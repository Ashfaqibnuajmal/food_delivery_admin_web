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
        color: AppColors.mediumBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: CustomTextStyles.header),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: icon,
                ),
              ],
            ),
            const Spacer(),
            Text(amount.toStringAsFixed(2), style: CustomTextStyles.header),
          ],
        ),
      ),
    );
  }
}
