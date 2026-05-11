import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/constants/expesnse_contants.dart';
import 'package:user_app/features/expances/presentation/provider/expense_provider.dart';
import '../../../../core/widgets/input_decoration.dart';

Future<void> customAddExpenseDialog({
  required BuildContext context,
  required void Function() onPressed,
}) async {
  final formKey = GlobalKey<FormState>();
  bool showDateError = false;

  return showDialog(
    context: context,
    builder: (context) {
      final provider = Provider.of<ExpenseProvider>(context);

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
                  // ---------------- DATE PICKER ----------------
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
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          ),
                        );

                        if (picked != null) {
                          provider.setDate(picked);
                          setState(() => showDateError = false);
                        }
                      } catch (e) {
                        log("Date Picker Error: $e");
                      }
                    },
                    icon: const Icon(Icons.date_range, color: Colors.white),
                    label: Text(
                      provider.date != null
                          ? provider.date.toString().split(" ")[0]
                          : "Pick Date",
                      style: CustomTextStyles.text,
                    ),
                  ),

                  // ---- DATE ERROR MESSAGE ----
                  if (showDateError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Date is required",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ---------------- CATEGORY ----------------
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(""),
                    initialValue: provider.category,
                    dropdownColor: AppColors.darkBlue,
                    style: CustomTextStyles.text,
                    hint: const Text(
                      "Select category",
                      style: TextStyle(color: Colors.white),
                    ),
                    items: ExpenseConstants.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    validator: (value) => validator(value, "Category"),
                    onChanged: (val) {
                      if (val != null) provider.setCategory(val);
                    },
                  ),

                  const SizedBox(height: 20),

                  // ---------------- AMOUNT ----------------
                  TextFormField(
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: inputDecoration(" Amount"),
                    style: CustomTextStyles.text,

                    // ✅ VALIDATION
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

                    // ✅ FIXED onChanged LOGIC
                    onChanged: (val) {
                      final parsed = double.tryParse(val);

                      if (parsed != null && parsed > 0) {
                        provider.setAmount(parsed.toInt());
                      } else {
                        provider.clearAmount(); // keep null if invalid
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ---------------- STATUS ----------------
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(""),
                    initialValue: provider.status,
                    dropdownColor: AppColors.darkBlue,
                    style: CustomTextStyles.text,
                    hint: const Text(
                      "Select Status",
                      style: TextStyle(color: Colors.white),
                    ),
                    items: ExpenseConstants.status.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    validator: (value) => validator(value, "Status"),
                    onChanged: (val) {
                      if (val != null) provider.setStatus(val);
                    },
                  ),

                  const SizedBox(height: 30),

                  // ---------------- ADD BUTTON ----------------
                  ElevatedButton(
                    onPressed: provider.isSubmitting
                        ? null // ❌ disables button
                        : () async {
                            if (provider.date == null) {
                              setState(() => showDateError = true);
                              return;
                            }

                            if (!formKey.currentState!.validate()) return;

                            try {
                              final providerRef = Provider.of<ExpenseProvider>(
                                context,
                                listen: false,
                              );

                              await providerRef.addExpense();

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Expense added successfully"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
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
                    child: provider.isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add Expense",
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
