import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_details_table_row.dart';

class DuePaymentTableBody extends StatelessWidget {
  final List<PaymentEntryModel> entries;

  const DuePaymentTableBody({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppColors.darkBlue.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return DuePaymentRow(entry: entry);
          },
        ),
      ),
    );
  }
}
