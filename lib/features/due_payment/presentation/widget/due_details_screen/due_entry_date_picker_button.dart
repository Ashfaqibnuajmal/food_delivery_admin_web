import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class DueEntryDatePickerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DueEntryDatePickerButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mediumBlue,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.date_range, color: AppColors.pureWhite),
      label: Text(label, style: CustomTextStyles.text),
    );
  }
}
