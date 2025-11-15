// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/features/due payment/data/model/due_user_model.dart';
import 'package:user_app/features/due payment/data/services/due_payment_services.dart';
import 'package:uuid/uuid.dart';

class DueUserController {
  /// Validator
  static String? validator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Handle Add User button
  static Future<void> handleAddUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    final userId = const Uuid().v4();
    final newUser = DueUserModel(
      userId: userId,
      name: name,
      phone: phone,
      email: email,
      balance: 0.0,
    );

    final duePaymentService = DuePaymentService();

    try {
      await duePaymentService.addDueUser(newUser);
      log("✅ Added user $name to Firestore");
      if (context.mounted) Navigator.pop(context);
      customSnackbar(context, "User added successfully", Colors.green);
    } catch (e) {
      log("❌ Error adding new due user: $e");
      customSnackbar(context, "Failed to add user", Colors.red);
    }
  }

  /// Handle update button click
  static Future<void> handleUpdateUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required DueUserModel currentUser,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final updatedUser = DueUserModel(
      userId: currentUser.userId,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      balance: currentUser.balance,
    );

    final duePaymentService = DuePaymentService();

    try {
      await duePaymentService.editDueUser(updatedUser);
      log("✅ User updated: ${updatedUser.name}");
      if (context.mounted) Navigator.pop(context);
      customSnackbar(context, "User updated successfully", Colors.green);
    } catch (e) {
      log("❌ Error editing user: $e");
      customSnackbar(context, "Failed to update user", Colors.red);
    }
  }
}
