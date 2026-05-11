import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/info_card.dart';

class PriceSummaryCard extends StatelessWidget {
  final String subtotal;
  final String discount;
  final String totalAmount;

  const PriceSummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: InfoCard(
        icon: Icons.payments_outlined,
        title: "Price Summary",
        child: Column(
          children: [
            PriceRow(label: "Subtotal", value: subtotal),

            const SizedBox(height: 10),

            PriceRow(label: "Discount", value: discount, isDiscount: true),

            const SizedBox(height: 10),

            const PriceRow(label: "Delivery Charge", value: "₹30"),

            Divider(
              color: AppColors.lightBlue.withOpacity(0.3),
              height: 24,
              thickness: 1,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: CustomTextStyles.nameStyle),

                Text(totalAmount, style: CustomTextStyles.nameStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.pureWhite.withOpacity(0.75),
            fontWeight: FontWeight.w400,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: isDiscount ? AppColors.errorRed : AppColors.pureWhite,
            fontWeight: FontWeight.w500,
            decoration: isDiscount
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: AppColors.errorRed,
            decorationThickness: 2.5,
          ),
        ),
      ],
    );
  }
}
