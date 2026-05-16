import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due_payment/logic/controller/due_entry_controller.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_details_table_header.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_entry_action_button.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_entry_table_cell.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/entry_edit.dart';
import 'package:user_app/features/due_payment/logic/provider/due_entry_action_provider.dart';
import 'package:user_app/features/due_payment/utils/due_date_format.dart';

class DuePaymentRow extends StatelessWidget {
  final PaymentEntryModel entry;

  const DuePaymentRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final dueEntryController = DueEntryController();

    return Container(
      width: DueDetailsTableHeader.tableMinWidth,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: AppColors.deepBlue.withOpacity(0.8)),
        ),
      ),
      child: Row(
        children: [
          DueEntryTableCell.text(
            flex: 2,
            value: DueDateFormatter.formatDate(entry.date),
          ),
          DueEntryTableCell.text(
            flex: 2,
            value: entry.status,
            style: CustomTextStyles.status(entry.status),
          ),
          DueEntryTableCell.text(
            flex: 3,
            value: "₹${entry.amount.toStringAsFixed(2)}",
          ),
          DueEntryTableCell.text(flex: 3, value: entry.notes),
          DueEntryTableCell(
            flex: 2,
            child: DueEntryActionButton(
              label: "Edit",
              backgroundColor: AppColors.deepBlue,
              onPressed: () {
                customEditEntryDialog(context: context, currentEntry: entry);
              },
            ),
          ),
          DueEntryTableCell(
            flex: 2,
            child: Consumer<DueEntryActionProvider>(
              builder: (context, actionProvider, _) {
                return DueEntryActionButton(
                  label: "Delete",
                  backgroundColor: Colors.redAccent,
                  isLoading: actionProvider.isDeletingEntry,
                  onPressed: () async {
                    final screenContext = context;

                    customDeleteDialog(screenContext, () async {
                      await actionProvider.runDeleteEntryAction(() {
                        return dueEntryController.deleteEntry(
                          dialogContext: screenContext,
                          screenContext: screenContext,
                          userId: entry.userId,
                          entryId: entry.entryId,
                        );
                      });
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
