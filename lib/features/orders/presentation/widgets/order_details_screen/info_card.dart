import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.addCategory.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 15 : null,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: isMobile ? 32 : 36,
                width: isMobile ? 32 : 36,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.darkBlue,
                  size: isMobile ? 16 : 18,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // CONTENT
          child,
        ],
      ),
    );
  }
}
