import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class SendNotificationHeader extends StatelessWidget {
  const SendNotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.mediumBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.campaign_rounded,
            color: AppColors.lightBlue,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send Notification', style: CustomTextStyles.header),
            Text('Broadcast to all users', style: CustomTextStyles.lightWhite),
          ],
        ),
      ],
    );
  }
}
