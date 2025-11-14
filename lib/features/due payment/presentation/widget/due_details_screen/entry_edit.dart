import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due payment/data/services/due_payment_services.dart';

Future<void> customEditEntryDialog({
  required BuildContext context,
  required PaymentEntryModel currentEntry,
}) async {
  final service = DuePaymentService();
  final formKey = GlobalKey<FormState>();

  // Local variables
  DateTime? selectedDate = currentEntry.date;
  String? status = currentEntry.status;
  double amount = currentEntry.amount;
  String notes = currentEntry.notes;

  bool showDateError = false;

  // Controllers
  final amountController = TextEditingController(
    text: currentEntry.amount.toString(),
  );
  final notesController = TextEditingController(text: currentEntry.notes);

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: AppColors.deepBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Edit Entry", style: CustomTextStyles.title),
                      const SizedBox(height: 20),

                      // 🔹 DATE PICKER
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
                              initialDate: selectedDate!,
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
                              setState(() {
                                selectedDate = picked;
                                showDateError = false;
                              });
                            }
                          } catch (e) {
                            log("Date Picker Error: $e");
                          }
                        },
                        icon: const Icon(
                          Icons.date_range,
                          color: AppColors.pureWhite,
                        ),
                        label: Text(
                          selectedDate.toString().split(" ")[0],
                          style: CustomTextStyles.text,
                        ),
                      ),

                      if (showDateError)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "Date is required",
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // 🔹 STATUS DROPDOWN
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration("Status"),
                        dropdownColor: AppColors.deepBlue,
                        initialValue: status, // pre-selected value
                        style: const TextStyle(color: AppColors.pureWhite),
                        items: const [
                          DropdownMenuItem(
                            value: "Paid",
                            child: Text(
                              "Paid",
                              style: TextStyle(color: AppColors.pureWhite),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Consumed",
                            child: Text(
                              "Consumed",
                              style: TextStyle(color: AppColors.pureWhite),
                            ),
                          ),
                        ],

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Status is required";
                          }
                          return null;
                        },

                        onChanged: (val) {
                          setState(() => status = val);
                        },
                      ),

                      const SizedBox(height: 20),

                      // 🔹 AMOUNT
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration("Enter Amount"),
                        style: const TextStyle(color: AppColors.pureWhite),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Amount is required";
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return "Enter a valid number";
                          }
                          return null;
                        },

                        onChanged: (v) =>
                            amount = double.tryParse(v.trim()) ?? amount,
                      ),

                      const SizedBox(height: 20),

                      // 🔹 NOTES
                      TextFormField(
                        controller: notesController,
                        keyboardType: TextInputType.text,
                        decoration: inputDecoration("Notes"),
                        style: const TextStyle(color: AppColors.pureWhite),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Notes are required";
                          }
                          return null;
                        },
                        onChanged: (v) => notes = v.trim(),
                      ),

                      const SizedBox(height: 30),

                      // 🔹 UPDATE BUTTON
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
                          // Date validation
                          if (selectedDate == null) {
                            setState(() => showDateError = true);
                            return;
                          }

                          if (!formKey.currentState!.validate()) return;

                          try {
                            final updatedEntry = PaymentEntryModel(
                              entryId: currentEntry.entryId,
                              userId: currentEntry.userId,
                              date: selectedDate!,
                              status: status!,
                              amount: amount,
                              notes: notes,
                            );

                            await service.editPaymentEntry(updatedEntry);
                            log("✅ Updated entry ${currentEntry.entryId}");

                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            log("❌ Error updating entry: $e");

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error updating entry"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Update Entry",
                          style: CustomTextStyles.buttonText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
