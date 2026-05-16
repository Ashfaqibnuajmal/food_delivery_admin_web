import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final double? height;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lightBlue, size: isMobile ? 15 : 16),

              const SizedBox(width: 8),

              Text(
                title,
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          Divider(color: AppColors.lightBlue.withOpacity(0.12), height: 24),

          child,
        ],
      ),
    );
  }
}
