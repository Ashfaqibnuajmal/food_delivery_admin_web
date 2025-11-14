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
  return showDialog(
    context: context,
    builder: (context) {
      final provider = Provider.of<ExpenseProvider>(context);

      return Dialog(
        backgroundColor: AppColors.deepBlue, // Theme background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Date Picker
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumBlue, // Theme button color
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
                    if (picked != null) provider.setDate(picked);
                  } catch (e) {
                    log("Date Picker Error: $e");
                  }
                },
                icon: const Icon(Icons.date_range, color: AppColors.pureWhite),
                label: Text(
                  provider.date != null
                      ? provider.date.toString().split(" ")[0]
                      : "Pick Date",
                  style: CustomTextStyles.text,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Category Dropdown
              DropdownButtonFormField<String>(
                decoration: inputDecoration(""),
                initialValue: provider.category,
                dropdownColor: AppColors.deepBlue,
                style: CustomTextStyles.text,
                hint: const Text(
                  "Select a category",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
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
                onChanged: (val) {
                  if (val != null) provider.setCategory(val);
                },
              ),
              const SizedBox(height: 20),

              // ✅ Amount Input
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Enter Amount"),
                style: CustomTextStyles.text,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    provider.setAmount(int.tryParse(val) ?? 0);
                  }
                },
              ),
              const SizedBox(height: 20),

              // ✅ Status Dropdown
              DropdownButtonFormField<String>(
                decoration: inputDecoration(""),
                initialValue: provider.status,
                dropdownColor: AppColors.deepBlue,
                style: CustomTextStyles.text,
                hint: const Text(
                  "Select a status",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                items: const [
                  DropdownMenuItem(value: "Paid", child: Text("Paid")),
                  DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
                ],
                onChanged: (val) {
                  if (val != null) provider.setStatus(val);
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
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
      );
    },
  );
}
