import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/core/validator/notification_validator.dart';

class NotificationTitleField extends StatelessWidget {
  final TextEditingController controller;

  const NotificationTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notification Title', style: CustomTextStyles.mediumWhiteText),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          style: const TextStyle(color: AppColors.pureWhite),
          decoration: InputDecoration(
            hintText: 'e.g. Service Unavailable',
            hintStyle: CustomTextStyles.lightWhite,

            prefixIcon: Icon(
              Icons.title,
              color: AppColors.lightBlue,
              size: isMobile ? 18 : 20,
            ),

            filled: true,
            fillColor: AppColors.darkBlue,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.mediumBlue.withOpacity(0.4),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.lightBlue,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.errorRed),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 1.5,
              ),
            ),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isMobile ? 12 : 14,
            ),
          ),
          validator: NotificationValidator.validateTitle,
        ),
      ],
    );
  }
}
