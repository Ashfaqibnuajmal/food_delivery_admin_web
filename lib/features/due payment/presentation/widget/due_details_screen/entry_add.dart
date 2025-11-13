import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due%20payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due%20payment/data/services/due_payment_services.dart';
import 'package:uuid/uuid.dart';

Future<void> customAddEntryDialog({
  required BuildContext context,
  required String userId, // current user's ID
}) async {
  final service = DuePaymentService();

  DateTime? selectedDate;
  String? status;
  double? amount;
  String? notes;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Add Entry", style: CustomTextStyles.title),
                const SizedBox(height: 20),

                // 🔹 Date Picker
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumBlue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.lightBlue,
                              surface: AppColors.deepBlue,
                              onSurface: AppColors.pureWhite,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        (context as Element).markNeedsBuild();
                      }
                    } catch (e) {
                      log("Date picker error: $e");
                    }
                  },
                  icon: const Icon(
                    Icons.date_range,
                    color: AppColors.pureWhite,
                  ),
                  label: Text(
                    selectedDate != null
                        ? selectedDate!.toString().split(" ")[0]
                        : "Pick Date",
                    style: CustomTextStyles.text,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Status Dropdown
                DropdownButtonFormField<String>(
                  decoration: inputDecoration("Status"),
                  dropdownColor: AppColors.deepBlue,
                  style: CustomTextStyles.text,
                  items: const [
                    DropdownMenuItem(value: "Paid", child: Text("Paid")),
                    DropdownMenuItem(
                      value: "Consumed",
                      child: Text("Consumed"),
                    ),
                  ],
                  onChanged: (val) => status = val,
                ),
                const SizedBox(height: 20),

                // 🔹 Amount field
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration("Enter Amount"),
                  style: const TextStyle(color: AppColors.pureWhite),
                  onChanged: (v) => amount = double.tryParse(v.trim()) ?? 0.0,
                ),
                const SizedBox(height: 20),

                // 🔹 Notes
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: inputDecoration("Notes"),
                  style: const TextStyle(color: AppColors.pureWhite),
                  onChanged: (v) => notes = v.trim(),
                ),
                const SizedBox(height: 30),

                // ✅  Add button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (selectedDate == null ||
                        status == null ||
                        amount == null ||
                        notes == null ||
                        notes!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("All fields are required"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final entryId = const Uuid().v4();
                    final entry = PaymentEntryModel(
                      entryId: entryId,
                      userId: userId,
                      date: selectedDate!,
                      status: status!,
                      amount: amount!,
                      notes: notes!,
                    );

                    try {
                      await service.addPaymentEntry(entry);
                      log("✅ Entry added for user $userId");
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      log("❌ Error adding entry: $e");
                    }
                  },
                  child: const Text(
                    "Add Entry",
                    style: CustomTextStyles.buttonText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
