import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/notification/provider/notification_provider.dart';

class DeleteNotificationDialog extends StatelessWidget {
  final String docId;
  final NotificationProvider provider;

  const DeleteNotificationDialog({
    super.key,
    required this.docId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth > 400
              ? 550
              : constraints.maxWidth * 0.9;

          return Container(
            width: maxWidth,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DELETE ICON
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever,
                    color: AppColors.pureWhite,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                // TITLE
                const Text("Delete?", style: CustomTextStyles.deleteTitle),

                const SizedBox(height: 12),

                // MESSAGE
                const Text(
                  "Are you sure you want to delete this notification?",
                  style: CustomTextStyles.deleteMessage,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // BUTTONS
                Row(
                  children: [
                    // CANCEL BUTTON
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightGrey,
                          foregroundColor: AppColors.pureWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "NO",
                          style: CustomTextStyles.yesORno,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // DELETE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await provider.deleteNotification(docId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          foregroundColor: AppColors.pureWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'YES',
                          style: CustomTextStyles.yesORno,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
