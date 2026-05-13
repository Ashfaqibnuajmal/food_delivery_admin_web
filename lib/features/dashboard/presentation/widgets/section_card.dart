import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final double? height; // ← make height optional

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.height, // ← no longer required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // ← null = wraps content automatically
      clipBehavior: Clip.hardEdge, // ← prevents any overflow
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ← shrink to content
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

          child, // ← removed Expanded, it caused the overflow
        ],
      ),
    );
  }
}
