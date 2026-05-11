import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due_payment/data/services/due_payment_services.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_details_header_info.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_details_table.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_details_table_header.dart';

class DueDetailsCard extends StatelessWidget {
  final String userId;
  final String userName;

  const DueDetailsCard({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final service = DuePaymentService();

    return Expanded(
      child: Center(
        child: Container(
          width: 780,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
            ],
          ),
          child: StreamBuilder<List<PaymentEntryModel>>(
            stream: service.fetchUserEntries(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.pureWhite),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Unable to load entries",
                    style: CustomTextStyles.buttonText,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No entries yet",
                    style: CustomTextStyles.buttonText,
                  ),
                );
              }

              final entries = snapshot.data!;

              return StreamBuilder<DueUserModel?>(
                stream: service.fetchDueUserById(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Unable to load balance",
                        style: CustomTextStyles.buttonText,
                      ),
                    );
                  }

                  final balance = userSnapshot.data?.balance ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserBalanceHeader(userName: userName, balance: balance),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: DueDetailsTableHeader.tableMinWidth,
                            child: Column(
                              children: [
                                const DueDetailsTableHeader(),
                                const SizedBox(height: 8),
                                DuePaymentTableBody(entries: entries),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
