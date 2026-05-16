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
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management',
                style: CustomTextStyles.loginHeading.copyWith(
                  fontSize: isMobile ? 22 : null,
                ),
              ),

              SizedBox(height: isMobile ? 18 : 25),

              const VoiceSearchBar(),

              SizedBox(height: isMobile ? 20 : 30),

              const UserSummaryCards(),

              SizedBox(height: isMobile ? 25 : 40),

              const Expanded(child: UserTable()),
            ],
          ),
        ),
      ),
    );
  }
}
