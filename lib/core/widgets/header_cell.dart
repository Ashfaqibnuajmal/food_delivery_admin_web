import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';

class HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const HeaderCell(this.label, {super.key, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: CustomTextStyles.tableHeader,
        ),
      ),
    );
  }
}
