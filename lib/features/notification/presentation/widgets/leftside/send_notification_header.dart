import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class SendNotificationHeader extends StatelessWidget {
  const SendNotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 10),
          decoration: BoxDecoration(
            color: AppColors.mediumBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.campaign_rounded,
            color: AppColors.lightBlue,
            size: isMobile ? 22 : 26,
          ),
        ),

        SizedBox(width: isMobile ? 10 : 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Notification',
                overflow: TextOverflow.ellipsis,
                style: isMobile
                    ? CustomTextStyles.header.copyWith(fontSize: 18)
                    : CustomTextStyles.header,
              ),

              const SizedBox(height: 2),

              Text(
                'Broadcast to all users',
                overflow: TextOverflow.ellipsis,
                style: isMobile
                    ? CustomTextStyles.lightWhite.copyWith(fontSize: 12)
                    : CustomTextStyles.lightWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
