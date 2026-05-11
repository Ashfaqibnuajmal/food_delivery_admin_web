import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/core/validator/notification_validator.dart';

class NotificationMessageField extends StatelessWidget {
  final TextEditingController controller;

  const NotificationMessageField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Message', style: CustomTextStyles.mediumWhiteText),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 6,
          style: const TextStyle(color: AppColors.pureWhite),
          decoration: InputDecoration(
            hintText: 'Write your message here...',
            hintStyle: CustomTextStyles.lightWhite,
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
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: NotificationValidator.validateMessage,
        ),
      ],
    );
  }
}
