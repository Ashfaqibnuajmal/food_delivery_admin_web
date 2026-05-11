import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class OrderItemsTableHeader extends StatelessWidget {
  const OrderItemsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.lightBlue.withOpacity(0.25)),
        ),
      ),
      child: const Row(
        children: [
          OrderItemHeaderCell("#", flex: 1),
          OrderItemHeaderCell("Item", flex: 5),
          OrderItemHeaderCell("Plate", flex: 2),
          OrderItemHeaderCell("Qty", flex: 2),
          OrderItemHeaderCell("Unit Price", flex: 2),
          OrderItemHeaderCell("Offer", flex: 2),
          OrderItemHeaderCell("Total", flex: 2),
        ],
      ),
    );
  }
}

class OrderItemHeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const OrderItemHeaderCell(this.label, {super.key, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: CustomTextStyles.header,
      ),
    );
  }
}
