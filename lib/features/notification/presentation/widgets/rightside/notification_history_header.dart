import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class NotificationHistoryHeader extends StatelessWidget {
  final NotificationProvider provider;
  const NotificationHistoryHeader({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Notification History', style: CustomTextStyles.header),
          ],
        ),

        StreamBuilder<QuerySnapshot>(
          stream: provider.getNotifications(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final count = snapshot.data!.docs.length;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.mediumBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.mediumBlue.withOpacity(0.4),
                ),
              ),
              child: Text(
                '$count Sent',
                style: CustomTextStyles.mediumWhiteText,
              ),
            );
          },
        ),
      ],
    );
  }
}
