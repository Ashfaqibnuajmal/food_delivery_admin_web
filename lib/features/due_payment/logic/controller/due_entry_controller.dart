// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/custom_snackbar.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due_payment/data/services/due_payment_services.dart';
import 'package:uuid/uuid.dart';

class DueEntryController {
  final DuePaymentService _duePaymentService;

  DueEntryController({DuePaymentService? duePaymentService})
    : _duePaymentService = duePaymentService ?? DuePaymentService();

  static const statusItems = [
    DropdownMenuItem(value: "Paid", child: Text("Paid")),
    DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
  ];

  String? validateStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Status is required";
    }

    return null;
  }

  String? validateAmount(String? value) {
    final amountText = value?.trim() ?? '';

    if (amountText.isEmpty) {
      return "Amount is required";
    }

    final amount = double.tryParse(amountText);

    if (amount == null) {
      return "Amount must be a valid number";
    }

    if (amount <= 0) {
      return "Amount must be greater than 0";
    }

    return null;
  }

  String? validateNotes(String? value) {
    final notes = value?.trim() ?? '';

    if (notes.isEmpty) {
      return "Notes is required";
    }

    return null;
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    return _showDatePicker(context, DateTime.now());
  }

  Future<DateTime?> pickEditDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    return _showDatePicker(context, initialDate);
  }

  Future<DateTime?> _showDatePicker(
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
      log("Date picker error: $e");
      return null;
    }
  }

  Future<void> addEntry({
    required BuildContext dialogContext,
    required BuildContext screenContext,
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

    final entry = PaymentEntryModel(
      entryId: const Uuid().v4(),
      userId: userId,
      date: selectedDate,
      status: status!,
      amount: amount!,
      notes: notes!,
    );

    try {
      await _duePaymentService.addPaymentEntry(entry);

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Entry added successfully", Colors.green);
      }

      log("Added entry for user $userId");
    } catch (e) {
      log("Error adding entry: $e");

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to add entry", Colors.red);
      }
    }
  }

  Future<void> updateEntry({
    required BuildContext dialogContext,
    required BuildContext screenContext,
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
    final updatedEntry = currentEntry.copyWith(
      date: selectedDate,
      status: status,
      amount: amount,
      notes: notes,
    );

    try {
      await _duePaymentService.editPaymentEntry(updatedEntry);

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(
          screenContext,
          "Entry updated successfully",
          Colors.green,
        );
      }

      log("Updated entry ${currentEntry.entryId}");
    } catch (e) {
      log("Error updating entry: $e");

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to update entry", Colors.red);
      }
    }
  }

  Future<void> deleteEntry({
    required BuildContext dialogContext,
    required BuildContext screenContext,
    required String userId,
    required String entryId,
  }) async {
    try {
      await _duePaymentService.deletePaymentEntry(userId, entryId);

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(
          screenContext,
          "Entry deleted successfully",
          Colors.green,
        );
      }

      log("Deleted entry $entryId");
    } catch (e) {
      log("Error deleting entry: $e");

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (screenContext.mounted) {
        customSnackbar(screenContext, "Failed to delete entry", Colors.red);
      }
    }
  }
}
