import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';

class NotificationContent extends StatelessWidget {
  final NotificationModel notification;

  const NotificationContent({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.title, style: CustomTextStyles.bigWhiteText),

          const SizedBox(height: 4),

          Text(notification.message, style: CustomTextStyles.lightWhite),
        ],
      ),
    );
  }
}
