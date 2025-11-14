import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/expances/provider/expance_provider.dart';
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
                    dropdownColor: AppColors.deepBlue,
                    style: CustomTextStyles.text,
                    hint: const Text(
                      "Select category",
                      style: TextStyle(color: Colors.white),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Electricity",
                        child: Text("Electricity"),
                      ),
                      DropdownMenuItem(
                        value: "Stationary",
                        child: Text("Stationary"),
                      ),
                      DropdownMenuItem(value: "Gas", child: Text("Gas")),
                      DropdownMenuItem(
                        value: "Room Rent",
                        child: Text("Room Rent"),
                      ),
                    ],
                    validator: (value) => validator(value, "Category"),
                    onChanged: (val) {
                      if (val != null) provider.setCategory(val);
                    },
                  ),

                  const SizedBox(height: 20),

                  // ---------------- AMOUNT ----------------
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("Enter Amount"),
                    style: CustomTextStyles.text,
                    validator: (value) => validator(value, "Amount"),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        provider.setAmount(int.tryParse(val) ?? 0);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ---------------- STATUS ----------------
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(""),
                    initialValue: provider.status,
                    dropdownColor: AppColors.deepBlue,
                    style: CustomTextStyles.text,
                    hint: const Text(
                      "Select Status",
                      style: TextStyle(color: Colors.white),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Paid", child: Text("Paid")),
                      DropdownMenuItem(
                        value: "Consumed",
                        child: Text("Consumed"),
                      ),
                    ],
                    validator: (value) => validator(value, "Status"),
                    onChanged: (val) {
                      if (val != null) provider.setStatus(val);
                    },
                  ),

                  const SizedBox(height: 30),

                  // ---------------- ADD BUTTON ----------------
                  ElevatedButton(
                    onPressed: () {
                      // Check Date
                      if (provider.date == null) {
                        setState(() => showDateError = true);
                        return;
                      }

                      // Validate Form Inputs
                      if (!formKey.currentState!.validate()) return;

                      onPressed();
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
