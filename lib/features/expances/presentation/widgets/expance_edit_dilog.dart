import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
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
  final amountController = TextEditingController(
    text: currentAmount.toString(),
  );

  // Temporary values while editing
  DateTime selectedDate = currentDate;
  String category = currentCategory;
  String status = currentStatus;

  await showDialog(
    context: context,
    builder: (context) {
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
                            onSurface: AppColors.pureWhite,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                    }
                  } catch (e) {
                    log("Date Picker Error: $e");
                  }
                },
                icon: const Icon(Icons.date_range, color: AppColors.pureWhite),
                label: Text(
                  selectedDate.toString().split(" ")[0],
                  style: CustomTextStyles.text,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Category Dropdown
              DropdownButtonFormField<String>(
                value: category,
                decoration: inputDecoration("Category"),
                dropdownColor: AppColors.deepBlue,
                style: CustomTextStyles.text,
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
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 20),

              // ✅ Amount Input
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Edit Amount"),
                style: CustomTextStyles.text,
              ),
              const SizedBox(height: 20),

              // ✅ Status Dropdown
              DropdownButtonFormField<String>(
                value: status,
                decoration: inputDecoration("Status"),
                dropdownColor: AppColors.deepBlue,
                style: CustomTextStyles.text,
                items: const [
                  DropdownMenuItem(value: "Paid", child: Text("Paid")),
                  DropdownMenuItem(value: "Consumed", child: Text("Consumed")),
                ],
                onChanged: (val) {
                  if (val != null) status = val;
                },
              ),
              const SizedBox(height: 30),

              // ✅ Save Changes Button
              ElevatedButton(
                onPressed: () {
                  final newAmount =
                      double.tryParse(amountController.text) ?? currentAmount;
                  onSave(selectedDate, category, newAmount, status);
                  Navigator.pop(context); // Close dialog
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
      );
    },
  );
}
