import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due%20payment/data/model/due_user_model.dart';
import 'package:user_app/features/due%20payment/data/services/due_payment_services.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_details_screen/due_details_table_header.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_payment_screen/due_payment_table.dart';

class DuePaymentTableContainer extends StatelessWidget {
  const DuePaymentTableContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final dueService = DuePaymentService();

    return Expanded(
      child: StreamBuilder<List<DueUserModel>>(
        stream: dueService.fetchDueUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pureWhite),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No due users found", style: CustomTextStyles.header),
            );
          }

          final users = snapshot.data!;

          return Consumer<UserSearchProvider>(
            builder: (context, search, _) {
              final filtered = users
                  .where(
                    (u) => u.name.toLowerCase().contains(
                      search.query.toLowerCase(),
                    ),
                  )
                  .toList();

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.1),
                  border: Border.all(color: AppColors.deepBlue, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const DuePaymentTableHeader(),
                    DuePaymentTable(users: filtered),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
