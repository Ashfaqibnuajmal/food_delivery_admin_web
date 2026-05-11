import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/users/data/model/user_model.dart';
import 'package:user_app/features/users/data/services/user_services.dart';
import 'package:user_app/features/users/presentation/widget/user_card.dart';

class UserSummaryCards extends StatelessWidget {
  const UserSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = context.read<UserServices>();
    return StreamBuilder<List<UserModel>>(
      stream: userService.fetchUsers(),
      builder: (context, snapshot) {
        // 🔄 LOADING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ ERROR STATE
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        // 📭 EMPTY STATE
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final users = snapshot.data!;

        // ✅ SAFE CALCULATIONS
        final total = users.length;
        final active = users
            .where((u) => u.status.toLowerCase() == 'active')
            .length;
        final blocked = users
            .where((u) => u.status.toLowerCase() == 'blocked')
            .length;

        // ✅ RESPONSIVE UI
        return LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;

            // ✅ Dynamic card width calculation
            int itemsPerRow = (screenWidth / 270).floor(); // 250 + spacing
            itemsPerRow = itemsPerRow < 1 ? 1 : itemsPerRow;

            double cardWidth =
                (screenWidth - (itemsPerRow - 1) * 16) / itemsPerRow;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center, // ✅ CENTERED
              children: [
                SizedBox(
                  width: cardWidth,
                  child: UserCard(
                    title: "Total Users",
                    count: total.toString(),
                    icon: Icons.person,
                    iconBg: AppColors.darkBlue,
                    cardColor: AppColors.mediumBlue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: UserCard(
                    title: "Active Users",
                    count: active.toString(),
                    icon: Icons.verified_user,
                    iconBg: Colors.green,
                    cardColor: AppColors.mediumBlue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: UserCard(
                    title: "Blocked Users",
                    count: blocked.toString(),
                    icon: Icons.person_off,
                    iconBg: Colors.red,
                    cardColor: AppColors.mediumBlue,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
