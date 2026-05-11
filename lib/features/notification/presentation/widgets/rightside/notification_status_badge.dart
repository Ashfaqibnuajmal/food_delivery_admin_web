import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class NotificationStatusBadge extends StatelessWidget {
  final String title;

  const NotificationStatusBadge({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.3)),
      ),
      child: Text(title, style: CustomTextStyles.mediumWhiteText),
    );
  }
}
