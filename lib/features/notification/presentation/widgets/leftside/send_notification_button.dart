import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class SendNotificationButton extends StatelessWidget {
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final NotificationProvider provider;
  const SendNotificationButton({
    super.key,
    required this.isLoading,
    required this.formKey,
    required this.titleController,
    required this.messageController,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: isLoading
            ? null
            : () async {
                if (formKey.currentState!.validate()) {
                  final title = titleController.text.trim();
                  final message = messageController.text.trim();

                  titleController.clear();
                  messageController.clear();
                  formKey.currentState!.reset();

                  await provider.sendNotification(
                    title: title,
                    message: message,
                  );
                }
              },
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: AppColors.pureWhite,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.send_rounded, size: 18),
        label: Text(
          isLoading ? 'Sending...' : 'Send to All Users',
          style: CustomTextStyles.addCategory,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mediumBlue,
          foregroundColor: AppColors.pureWhite,
          disabledBackgroundColor: AppColors.mediumBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
