import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';

class DuePaymentTableCell extends StatelessWidget {
  final Widget child;

  const DuePaymentTableCell({super.key, required this.child});

  factory DuePaymentTableCell.text(String value) {
    return DuePaymentTableCell(
      child: Text(
        value,
        style: CustomTextStyles.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: child));
  }
}
