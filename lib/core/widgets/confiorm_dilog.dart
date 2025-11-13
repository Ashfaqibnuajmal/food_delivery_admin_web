import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

customDeleteDialog(BuildContext context, VoidCallback? onPress) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔴 Delete Icon
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

              // 📝 Title
              const Text('Delete', style: CustomTextStyles.deleteTitle),

              const SizedBox(height: 12),

              // ⚠️ Message
              const Text(
                'Are you sure you want to delete this item?',
                style: CustomTextStyles.deleteMessage,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ✅ Buttons
              Row(
                children: [
                  // ❌ NO button
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
                      child: const Text('NO', style: CustomTextStyles.yesORno),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ✅ YES button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        foregroundColor: AppColors.pureWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('YES', style: CustomTextStyles.yesORno),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
