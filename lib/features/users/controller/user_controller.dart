// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/features/users/data/services/user_services.dart';

class UserTableLogic {
  /// Handle block/unblock user actions
  static Future<void> handleUserAction({
    required BuildContext context,
    required dynamic user,
    required bool isActive,
  }) async {
    try {
      final userService = UserServices();

      if (isActive) {
        await userService.blockUser(user.uid); // Block the user
        customSnackbar(context, "User blocked successfully", Colors.red);
      } else {
        await userService.unblockUser(user.uid); // Unblock the user
        customSnackbar(context, "User unblocked successfully", Colors.green);
      }

      // Refresh provider list to reflect changes
      final provider = context.read<UserSearchProvider>();
      final currentUsers = provider.allUsers;
      provider.setUsers([...currentUsers]);
    } catch (e) {
      customSnackbar(
        context,
        "Failed to update user",
        Colors.red,
      ); // Show error
    }
  }
}
