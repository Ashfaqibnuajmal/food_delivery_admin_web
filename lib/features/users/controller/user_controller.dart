import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/features/users/data/model/user_model.dart';
import 'package:user_app/features/users/data/services/user_services.dart';

class UserController {
  static Future<void> toggleUserStatus({
    required BuildContext context,
    required UserModel user,
  }) async {
    final isActive = user.status.toLowerCase() == 'active';

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.deepBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                    // 🔴 / 🟢 ICON (same style as delete)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.errorRed : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.person_off : Icons.verified_user,
                        color: AppColors.pureWhite,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 📝 TITLE (same style)
                    Text(
                      isActive ? 'Block User' : 'Unblock User',
                      style: CustomTextStyles.deleteTitle,
                    ),

                    const SizedBox(height: 12),

                    // ⚠️ MESSAGE (same style)
                    Text(
                      isActive
                          ? 'Are you sure you want to block this user?'
                          : 'Are you sure you want to unblock this user?',
                      style: CustomTextStyles.deleteMessage,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // ✅ BUTTONS (IDENTICAL STRUCTURE)
                    Row(
                      children: [
                        // ❌ NO
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.lightGrey,
                              foregroundColor: AppColors.pureWhite,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'NO',
                              style: CustomTextStyles.yesORno,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ✅ YES
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? AppColors.errorRed
                                  : Colors.green,
                              foregroundColor: AppColors.pureWhite,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isActive ? 'BLOCK' : 'UNBLOCK',
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
      },
    );

    // ❌ If cancelled → stop here
    if (confirm != true) return;

    // ✅ CONTINUE ACTION
    try {
      final userService = context.read<UserServices>();

      if (isActive) {
        await userService.blockUser(user.uid);
        customSnackbar(context, "User blocked successfully", Colors.red);
      } else {
        await userService.unblockUser(user.uid);
        customSnackbar(context, "User unblocked successfully", Colors.green);
      }
    } catch (e) {
      customSnackbar(context, "Failed to update user", Colors.red);
    }
  }
}
