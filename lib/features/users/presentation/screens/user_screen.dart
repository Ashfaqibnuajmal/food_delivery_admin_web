import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/voice_search_bar.dart';
import 'package:user_app/features/users/presentation/widget/user_summary_card.dart';
import 'package:user_app/features/users/presentation/widget/user_table.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Management',
                style: CustomTextStyles.loginHeading,
              ),
              const SizedBox(height: 25),
              const VoiceSearchBar(),
              const SizedBox(height: 30),
              const UserSummaryCards(), // ✅ CLEAN
              const SizedBox(height: 40),
              const UserTable(), // ✅ CLEAN
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
