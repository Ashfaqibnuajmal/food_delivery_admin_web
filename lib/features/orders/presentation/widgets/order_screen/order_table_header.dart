import 'package:flutter/material.dart';
import 'package:user_app/core/widgets/header_cell.dart';
import 'package:user_app/core/theme/web_color.dart';

class OrderTableHeader extends StatelessWidget {
  const OrderTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          HeaderCell("#", flex: 1),
          HeaderCell("User", flex: 2),
          HeaderCell("Location", flex: 2),
          HeaderCell("Phone Number", flex: 2),
          HeaderCell("Items", flex: 3),
          HeaderCell("Amount", flex: 2),
          HeaderCell("Payment", flex: 2),
          HeaderCell("Action", flex: 3),
          HeaderCell("View", flex: 2),
        ],
      ),
    );
  }
}
