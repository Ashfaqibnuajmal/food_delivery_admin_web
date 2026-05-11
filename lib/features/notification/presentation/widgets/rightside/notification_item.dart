import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_content.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_delete_button.dart';
import 'package:user_app/features/notification/presentation/widgets/rightside/notification_status_badge.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ICON
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.mediumBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.notifications_rounded,
            color: AppColors.lightBlue,
            size: 20,
          ),
        ),

        const SizedBox(width: 16),

        // CONTENT
        NotificationContent(notification: notification),

        const SizedBox(width: 12),

        // STATUS
        const NotificationStatusBadge(title: 'Sent'),

        const SizedBox(width: 10),

        // DELETE BUTTON
        NotificationDeleteButton(onPressed: onDelete),
      ],
    );
  }
}
