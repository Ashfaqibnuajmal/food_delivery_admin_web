import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_payment_screen/due_payment_add.dart';

class DuePaymentHeader extends StatelessWidget {
  final String title;

  const DuePaymentHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CustomTextStyles.loginHeading),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            customAddDuePaymentDialog(context: context);
          },
          child: const Text(
            "Add Due Payment",
            style: CustomTextStyles.buttonText,
          ),
        ),
      ],
    );
  }
}
