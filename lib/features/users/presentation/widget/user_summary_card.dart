import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/users/data/services/user_services.dart';
import 'user_card.dart';

class UserSummaryCards extends StatelessWidget {
  final UserServices userService;

  const UserSummaryCards({super.key, required this.userService});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<int>(
          stream: userService.totalUsersCount(),
          builder: (context, snapshot) => UserCard(
            title: "Total Users",
            count: snapshot.data?.toString() ?? "0",
            icon: Icons.person,
            iconBg: AppColors.darkBlue,
            cardColor: AppColors.mediumBlue,
          ),
        ),
        StreamBuilder<int>(
          stream: userService.activeUsersCount(),
          builder: (context, snapshot) => UserCard(
            title: "Active Users",
            count: snapshot.data?.toString() ?? "0",
            icon: Icons.verified_user,
            iconBg: Colors.green,
            cardColor: AppColors.mediumBlue,
          ),
        ),
        StreamBuilder<int>(
          stream: userService.blockedUsersCount(),
          builder: (context, snapshot) => UserCard(
            title: "Blocked Users",
            count: snapshot.data?.toString() ?? "0",
            icon: Icons.person_off,
            iconBg: Colors.red,
            cardColor: AppColors.mediumBlue,
          ),
        ),
      ],
    );
  }
}
