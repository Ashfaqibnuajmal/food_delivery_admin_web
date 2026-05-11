import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class ChatDeleteDialog extends StatelessWidget {
  final String messageText;
  final VoidCallback onConfirm;

  const ChatDeleteDialog({
    super.key,
    required this.messageText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 400
              ? 550
              : constraints.maxWidth * 0.9;

          return Container(
            width: maxWidth,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔴 ICON
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

                /// 📝 TITLE
                const Text(
                  "Delete Message?",
                  style: CustomTextStyles.deleteTitle,
                ),

                const SizedBox(height: 12),

                /// 💬 MESSAGE PREVIEW
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.mediumBlue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    messageText.length > 60
                        ? "${messageText.substring(0, 60)}..."
                        : messageText,
                    style: CustomTextStyles.deleteMessage.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "This action cannot be undone.",
                  style: CustomTextStyles.deleteMessage.copyWith(
                    fontSize: 13,
                    color: AppColors.pureWhite.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 24),

                /// 🔘 BUTTONS
                Row(
                  children: [
                    /// ❌ NO
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightGrey,
                        ),
                        child: const Text(
                          'NO',
                          style: CustomTextStyles.yesORno,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ✅ YES
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
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
