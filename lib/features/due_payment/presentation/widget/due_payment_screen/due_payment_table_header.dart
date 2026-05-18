import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

import '../../../../../core/widgets/header_cell.dart';

class DuePaymentTableHeader extends StatelessWidget {
  const DuePaymentTableHeader({super.key});

  static const double tableMinWidth = 980;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableMinWidth,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          HeaderCell("Name"),
          HeaderCell("Phone No"),
          HeaderCell("Email"),
          HeaderCell("Balance Due"),
          HeaderCell("Edit"),
          HeaderCell("Delete"),
        ],
      ),
    );
  }
}
