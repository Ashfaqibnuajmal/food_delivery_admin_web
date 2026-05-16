import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';

class HeaderCell extends StatelessWidget {
  final String title;

  const HeaderCell({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.loginHeading.copyWith(
              fontSize: isMobile ? 12 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
