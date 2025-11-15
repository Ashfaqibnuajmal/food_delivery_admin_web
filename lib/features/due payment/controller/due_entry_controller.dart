// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/cutom_snackbar.dart';
import 'package:user_app/features/due payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due payment/data/services/due_payment_services.dart';
import 'package:uuid/uuid.dart';

class DuePaymentController {
  /// Dropdown items for status
  static const statusItems = [
    DropdownMenuItem(value: "Paid", child: Text("Paid")),
    DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
  ];

  /// Validator for all fields
  static String? validator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Pick date helper
  static Future<DateTime?> pickDate(BuildContext context) async {
    try {
      return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.lightBlue,
              surface: AppColors.deepBlue,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        ),
      );
    } catch (e) {
      log("Date Picker Error: $e");
      return null;
    }
  }

  static Future<DateTime?> pickEditDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    try {
      return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.lightBlue,
              surface: AppColors.deepBlue,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        ),
      );
    } catch (e) {
      log("Date Picker Error: $e");
      return null;
    }
  }

  /// Handle Add Entry button
  static Future<void> handleAddEntry({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required DateTime? selectedDate,
    required String? status,
    required double? amount,
    required String? notes,
    required String userId,
    required void Function(bool val) setShowDateError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      setShowDateError(true);
      return;
    }

    final service = DuePaymentService();
    final entry = PaymentEntryModel(
      entryId: const Uuid().v4(),
      userId: userId,
      date: selectedDate,
      status: status!,
      amount: amount!,
      notes: notes!,
    );

    try {
      await service.addPaymentEntry(entry);
      customSnackbar(context, "Entry added successfully", Colors.green);
      if (context.mounted) Navigator.pop(context);
      log("✅ Entry added for user $userId");
    } catch (e) {
      customSnackbar(context, "Failed to add entry", Colors.red);
      log("❌ Error adding entry: $e");
    }
  }

  /// Handle update button click
  static Future<void> handleUpdateEntry({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required PaymentEntryModel currentEntry,
    required DateTime? selectedDate,
    required String? status,
    required double amount,
    required String notes,
    required void Function(bool val) setShowDateError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      setShowDateError(true);
      return;
    }

    final service = DuePaymentService();
    final updatedEntry = PaymentEntryModel(
      entryId: currentEntry.entryId,
      userId: currentEntry.userId,
      date: selectedDate,
      status: status!,
      amount: amount,
      notes: notes,
    );

    try {
      await service.editPaymentEntry(updatedEntry);
      customSnackbar(context, "Entry updated successfully", Colors.green);
      if (context.mounted) Navigator.pop(context);
      log("✅ Updated entry ${currentEntry.entryId}");
    } catch (e) {
      customSnackbar(context, "Failed to update entry", Colors.red);
      log("❌ Error updating entry: $e");
    }
  }
}
