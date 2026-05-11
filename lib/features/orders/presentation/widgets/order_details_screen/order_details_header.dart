import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 12),

        const Text("Order Details", style: CustomTextStyles.loginHeading),

        const Spacer(),

        // Back button
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightBlue.withOpacity(0.35)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.lightBlue,
                  size: 14,
                ),

                SizedBox(width: 6),

                Text("Back", style: CustomTextStyles.buttonText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
