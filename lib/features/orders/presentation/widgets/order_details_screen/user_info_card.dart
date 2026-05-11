import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/info_card.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;

  const UserInfoCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: InfoCard(
        icon: Icons.person,
        title: "User Info",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: CustomTextStyles.nameStyle),

            const SizedBox(height: 12),

            UserInfoRow(icon: Icons.call_rounded, text: phone),

            const SizedBox(height: 8),

            UserInfoRow(icon: Icons.location_on_rounded, text: address),
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const UserInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.lightBlue),

        const SizedBox(width: 8),

        Expanded(child: Text(text, style: CustomTextStyles.mediumWhiteText)),
      ],
    );
  }
}
