import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white),
    hintText: "Enter $label",
    hintStyle: const TextStyle(color: Colors.white),
    filled: true,
    fillColor: AppColors.darkBlue,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

String? validator(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return "$fieldName is required";
  }
  return null;
}

String? dateValidator(DateTime? value) {
  if (value == null) return "Date is required";
  return null;
}
