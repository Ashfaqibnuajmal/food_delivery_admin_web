import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/constants/expesnse_contants.dart';
import '../../../../core/widgets/input_decoration.dart';

Future<void> showEditExpenseDialog({
  required BuildContext context,
  required DateTime currentDate,
  required String currentCategory,
  required double currentAmount,
  required String currentStatus,
  required void Function(
    DateTime newDate,
    String newCategory,
    double newAmount,
    String newStatus,
  )
  onSave,
}) async {
  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController(
    text: currentAmount.toString(),
  );

  // Temporary editable values (non-nullable because we start with current values)
  DateTime selectedDate = currentDate;
  String category = currentCategory;
  String status = currentStatus;
  bool showDateError = false;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Dialog(
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ----------------- DATE PICKER -----------------
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
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.lightBlue,
                                surface: AppColors.deepBlue,
                                onSurface: Colors.white,
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
                    icon: const Icon(Icons.date_range, color: Colors.white),
                    label: Text(
                      DateFormat('dd MMM yyyy').format(selectedDate),
                      style: CustomTextStyles.text,
                    ),
                  ),

                  // ---- DATE ERROR (only shown if you set showDateError true) ----
                  if (showDateError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Date is required",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ----------------- CATEGORY DROPDOWN -----------------
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: inputDecoration("Category"),
                    dropdownColor: AppColors.darkBlue,
                    style: CustomTextStyles.text,
                    items: ExpenseConstants.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => category = val);
                    },
                    validator: (value) => validator(value, "Category"),
                  ),

                  const SizedBox(height: 20),

                  // ----------------- AMOUNT FIELD -----------------
                  TextFormField(
                    autofocus: true,
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: inputDecoration("Edit Amount"),
                    style: CustomTextStyles.text,

                    // ✅ VALIDATION ONLY
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Amount is required";
                      }

                      final number = double.tryParse(value);

                      if (number == null) {
                        return "Enter valid number";
                      }

                      if (number <= 0) {
                        return "Amount must be greater than 0";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ----------------- STATUS DROPDOWN -----------------
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: inputDecoration("Status"),
                    dropdownColor: AppColors.darkBlue,
                    style: CustomTextStyles.text,
                    items: ExpenseConstants.status.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => status = val);
                    },
                    validator: (value) => validator(value, "Status"),
                  ),

                  const SizedBox(height: 30),

                  // ----------------- SAVE BUTTON -----------------
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      // Parse amount safely
                      final newAmount = double.parse(amountController.text);

                      onSave(selectedDate, category, newAmount, status);
                      Navigator.pop(context);
                    },
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
                    child: const Text(
                      "Save Changes",
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
}
