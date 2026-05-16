// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/data/services/due_payment_services.dart';
import 'package:uuid/uuid.dart';

class DueUserController {
  final DuePaymentService _duePaymentService;

  DueUserController({DuePaymentService? duePaymentService})
    : _duePaymentService = duePaymentService ?? DuePaymentService();

  String? validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name)) {
      return 'Name can only contain letters';
    }

    return null;
  }

  String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Phone number is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Phone number can only contain digits';
    }

    if (phone.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> addUser({
    required BuildContext dialogContext,
    required BuildContext screenContext,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
  }) async {
    if (!formKey.currentState!.validate()) return;
    final newUser = DueUserModel(
      userId: const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      balance: 0.0,
      createdAt: DateTime.now(),
    );

    try {
      final alreadyExists = await _duePaymentService.dueUserExists(
        phone: newUser.phone,
        email: newUser.email,
      );

      if (alreadyExists) {
        if (screenContext.mounted) {
          customSnackbar(
            screenContext,
            "Phone number or email already exists",
            Colors.red,
          );
        }
        return;
      }

      await _duePaymentService.addDueUser(newUser);
      log("Added due user: ${newUser.name}");

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(screenContext, "User added successfully", Colors.green);
      }
    } catch (e) {
      log("Error adding due user: $e");

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to add user", Colors.red);
      }
    }
  }

  Future<void> updateUser({
    required BuildContext dialogContext,
    required BuildContext screenContext,
    required GlobalKey<FormState> formKey,
    required DueUserModel currentUser,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
  }) async {
    if (!formKey.currentState!.validate()) return;
    final updatedUser = currentUser.copyWith(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
    );

    try {
      final alreadyExists = await _duePaymentService.dueUserExists(
        phone: updatedUser.phone,
        email: updatedUser.email,
        excludeUserId: updatedUser.userId,
      );

      if (alreadyExists) {
        if (screenContext.mounted) {
          customSnackbar(
            screenContext,
            "Phone number or email already exists",
            Colors.red,
          );
        }
        return;
      }

      await _duePaymentService.editDueUser(updatedUser);
      log("Updated due user: ${updatedUser.name}");

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(
          screenContext,
          "User updated successfully",
          Colors.green,
        );
      }
    } catch (e) {
      log("Error updating due user: $e");

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to update user", Colors.red);
      }
    }
  }

  Future<void> deleteUser({
    required BuildContext dialogContext,
    required BuildContext screenContext,
    required String userId,
  }) async {
    try {
      await _duePaymentService.deleteDueUser(userId);

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(
          screenContext,
          "User deleted successfully",
          Colors.green,
        );
      }
    } catch (e) {
      log("Error deleting due user: $e");

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to delete user", Colors.red);
      }
    }
  }
}
