import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due_payment/data/enum/due_user_sort_type.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/data/services/due_payment_services.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';

class DuePaymentTableContainer extends StatelessWidget {
  const DuePaymentTableContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final dueService = DuePaymentService();

    return Expanded(
      child: StreamBuilder<List<DueUserModel>>(
        stream: dueService.fetchDueUsers(sortType: DueUserSortType.latest),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pureWhite),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Unable to load due users",
                style: CustomTextStyles.header,
              ),
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
              final query = search.query.trim().toLowerCase();

              final filtered = users.where((user) {
                final name = user.name.toLowerCase();
                final phone = user.phone.toLowerCase();
                final email = user.email.toLowerCase();

                return name.contains(query) ||
                    phone.contains(query) ||
                    email.contains(query);
              }).toList();

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.1),
                  border: Border.all(color: AppColors.deepBlue, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: DuePaymentTableHeader.tableMinWidth,
                    child: Column(
                      children: [
                        const DuePaymentTableHeader(),

                        if (filtered.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                "No matching users found",
                                style: CustomTextStyles.header,
                              ),
                            ),
                          )
                        else
                          DuePaymentTable(users: filtered),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
