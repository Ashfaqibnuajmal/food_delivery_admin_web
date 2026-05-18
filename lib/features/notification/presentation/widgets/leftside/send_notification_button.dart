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
    final isMobile = MediaQuery.of(context).size.width < 700;

    return SizedBox(
      width: double.infinity,
      height: isMobile ? 46 : 48,
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
            ? SizedBox(
                width: isMobile ? 16 : 18,
                height: isMobile ? 16 : 18,
                child: const CircularProgressIndicator(
                  color: AppColors.pureWhite,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.send_rounded, size: isMobile ? 16 : 18),

        label: Flexible(
          child: Text(
            isLoading ? 'Sending...' : 'Send to All Users',
            overflow: TextOverflow.ellipsis,
            style: isMobile
                ? CustomTextStyles.addCategory.copyWith(fontSize: 13)
                : CustomTextStyles.addCategory,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mediumBlue,
          foregroundColor: AppColors.pureWhite,
          disabledBackgroundColor: AppColors.mediumBlue.withOpacity(0.3),

          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          elevation: 0,
        ),
      ),
    );
  }
}
