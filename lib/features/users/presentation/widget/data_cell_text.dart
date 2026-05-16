import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';

class DataCellText extends StatelessWidget {
  final String data;

  const DataCellText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
        child: Center(
          child: Text(
            data,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.text.copyWith(
              fontSize: isMobile ? 11 : null,
            ),
          ),
        ),
      ),
    );
  }
}
