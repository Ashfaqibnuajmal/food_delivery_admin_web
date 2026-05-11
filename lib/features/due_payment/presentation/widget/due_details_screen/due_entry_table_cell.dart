import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';

class DueEntryTableCell extends StatelessWidget {
  final int flex;
  final Widget child;

  const DueEntryTableCell({super.key, required this.flex, required this.child});

  factory DueEntryTableCell.text({
    required int flex,
    required String value,
    TextStyle? style,
  }) {
    return DueEntryTableCell(
      flex: flex,
      child: Text(
        value,
        style: style ?? CustomTextStyles.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(child: child),
    );
  }
}
