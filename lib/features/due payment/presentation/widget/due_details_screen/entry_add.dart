import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due%20payment/controller/due_entry_controller.dart';

Future<void> customAddEntryDialog({
  required BuildContext context,
  required String userId,
}) async {
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? status;
  double? amount;
  String? notes;
  bool showDateError = false;

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
                          final picked = await DuePaymentController.pickDate(
                            context,
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
                          selectedDate != null
                              ? selectedDate!.toString().split(" ")[0]
                              : "Pick Date",
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

                      // 🔹 Status Dropdown
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration(""),
                        dropdownColor: AppColors.deepBlue,
                        style: CustomTextStyles.text,
                        hint: const Text(
                          "Select a status",
                          style: TextStyle(color: Colors.white),
                        ),
                        items: DuePaymentController.statusItems,
                        validator: (value) =>
                            DuePaymentController.validator(value, "Status"),
                        onChanged: (val) => status = val,
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Amount field
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration("Enter Amount"),
                        style: const TextStyle(color: AppColors.pureWhite),
                        validator: (value) =>
                            DuePaymentController.validator(value, "Amount"),
                        onChanged: (v) =>
                            amount = double.tryParse(v.trim()) ?? 0.0,
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Notes
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: inputDecoration("Notes"),
                        style: const TextStyle(color: AppColors.pureWhite),
                        validator: (value) =>
                            DuePaymentController.validator(value, "Notes"),
                        onChanged: (v) => notes = v.trim(),
                      ),
                      const SizedBox(height: 30),

                      // ✅ Add button
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
                          DuePaymentController.handleAddEntry(
                            context: context,
                            formKey: formKey,
                            selectedDate: selectedDate,
                            status: status,
                            amount: amount,
                            notes: notes,
                            userId: userId,
                            setShowDateError: (val) => showDateError = val,
                          );
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
            ),
          );
        },
      );
    },
  );
}
