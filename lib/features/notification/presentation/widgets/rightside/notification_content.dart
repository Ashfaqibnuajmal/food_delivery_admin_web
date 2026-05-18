import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';

class NotificationContent extends StatelessWidget {
  final NotificationModel notification;

  const NotificationContent({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            notification.title,
            maxLines: isMobile ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bigWhiteText,
          ),

          const SizedBox(height: 6),

          Text(
            notification.message,
            maxLines: isMobile ? 3 : 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.lightWhite,
          ),
        ],
      ),
    );
  }
}
