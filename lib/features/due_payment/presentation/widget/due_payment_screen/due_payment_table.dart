import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/due_payment/controller/due_user_controller.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/presentation/screens/due_payment_view_screen.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_action.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_edit.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_cell.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';
import 'package:user_app/features/due_payment/provider/due_user_action_provider.dart';

class DuePaymentTable extends StatelessWidget {
  final List<DueUserModel> users;

  const DuePaymentTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final dueUserController = DueUserController();

    return Expanded(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            width: DuePaymentTableHeader.tableMinWidth,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.05),
              border: const Border(bottom: BorderSide(color: Colors.black26)),
            ),
            child: Row(
              children: [
                DuePaymentTableCell.text(user.name),
                DuePaymentTableCell.text(user.phone),
                DuePaymentTableCell.text(user.email),
                DuePaymentTableCell.text("₹${user.balance.toStringAsFixed(2)}"),
                DuePaymentTableCell(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DuePaymentViewScreen(
                            userId: user.userId,
                            userName: user.name,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View",
                      style: CustomTextStyles.viewStyle,
                    ),
                  ),
                ),

                DuePaymentTableCell(
                  child: DuePaymentActionButton(
                    label: "Edit",
                    backgroundColor: AppColors.deepBlue,
                    onPressed: () {
                      customEditDuePaymentDialog(
                        context: context,
                        currentUser: user,
                      );
                    },
                  ),
                ),
                DuePaymentTableCell(
                  child: Consumer<DueUserActionProvider>(
                    builder: (context, actionProvider, _) {
                      return DuePaymentActionButton(
                        label: "Delete",
                        backgroundColor: Colors.redAccent,
                        isLoading: actionProvider.isDeletingUser,
                        onPressed: () {
                          final screenContext = context;

                          customDeleteDialog(screenContext, () async {
                            await actionProvider.runDeleteAction(() {
                              return dueUserController.deleteUser(
                                dialogContext: screenContext,
                                screenContext: screenContext,
                                userId: user.userId,
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
        },
      ),
    );
  }
}
