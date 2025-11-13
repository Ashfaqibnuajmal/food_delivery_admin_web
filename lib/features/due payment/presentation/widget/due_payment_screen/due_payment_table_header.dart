import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class DuePaymentTableHeader extends StatelessWidget {
  const DuePaymentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          HeaderCell(title: "Name"),
          HeaderCell(title: "Phone No"),
          HeaderCell(title: "Email"),
          HeaderCell(title: "Balance Due"),
          HeaderCell(title: "View"),
          HeaderCell(title: "Edit"),
          HeaderCell(title: "Delete"),
        ],
      ),
    );
  }
}

class HeaderCell extends StatelessWidget {
  final String title;

  const HeaderCell({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text(title, style: CustomTextStyles.header)),
    );
  }
}
