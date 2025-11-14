import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/due%20payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due%20payment/data/services/due_payment_services.dart';
import 'package:user_app/features/due%20payment/presentation/widget/due_details_screen/entry_edit.dart';

class DuePaymentRow extends StatelessWidget {
  final PaymentEntryModel entry;
  final DuePaymentService service;

  const DuePaymentRow({super.key, required this.entry, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: AppColors.deepBlue.withOpacity(0.8)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                entry.date.toString().split(" ")[0],
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                entry.status,
                style: CustomTextStyles.status(entry.status),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "₹${entry.amount.toStringAsFixed(2)}",
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(entry.notes, style: CustomTextStyles.text),
            ),
          ),
          // Edit button
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                ),
                onPressed: () {
                  customEditEntryDialog(context: context, currentEntry: entry);
                },
                child: const Text("Edit", style: CustomTextStyles.text),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  customDeleteDialog(context, () async {
                    await service.deletePaymentEntry(
                      entry.userId,
                      entry.entryId,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  });
                },
                child: const Text("Delete", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
