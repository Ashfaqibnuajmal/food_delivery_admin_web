import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due%20payment/controller/due_entry_controller.dart';

Future<void> customEditEntryDialog({
  required BuildContext context,
  required PaymentEntryModel currentEntry,
}) async {
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate = currentEntry.date;
  String? status = currentEntry.status;
  double amount = currentEntry.amount;
  String notes = currentEntry.notes;

  bool showDateError = false;

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
                          final picked =
                              await DuePaymentController.pickEditDate(
                                context,
                                selectedDate!,
                              );
                          if (picked != null) {
                            selectedDate = picked;
                            setState(() => showDateError = false);
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

                      // 🔹 STATUS
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration("Status"),
                        dropdownColor: AppColors.deepBlue,
                        initialValue: status,
                        style: const TextStyle(color: AppColors.pureWhite),
                        items: DuePaymentController.statusItems,
                        validator: (value) =>
                            DuePaymentController.validator(value, "Status"),
                        onChanged: (val) => status = val,
                      ),
                      const SizedBox(height: 20),

                      // 🔹 AMOUNT
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration("Enter Amount"),
                        style: const TextStyle(color: AppColors.pureWhite),
                        validator: (value) =>
                            DuePaymentController.validator(value, "Amount"),
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
                        validator: (value) =>
                            DuePaymentController.validator(value, "Notes"),
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
                        onPressed: () {
                          DuePaymentController.handleUpdateEntry(
                            context: context,
                            formKey: formKey,
                            currentEntry: currentEntry,
                            selectedDate: selectedDate,
                            status: status,
                            amount: amount,
                            notes: notes,
                            setShowDateError: (val) => showDateError = val,
                          );
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
