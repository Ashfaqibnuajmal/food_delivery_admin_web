import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class UserCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconBg;
  final Color cardColor;

  const UserCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconBg,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: CustomTextStyles.addCategory.copyWith(
                  color: AppColors.pureWhite.withOpacity(0.75),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.darkBlue, size: 18),
              ),
            ],
          ),

          const Spacer(),

          // COUNT
          Text(
            count,
            style: CustomTextStyles.nameStyle.copyWith(
              color: AppColors.pureWhite,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
