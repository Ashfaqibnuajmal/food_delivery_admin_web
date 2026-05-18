import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/delete_dilog.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/logic/controller/due_user_controller.dart';
import 'package:user_app/features/due_payment/logic/provider/due_user_action_provider.dart';
import 'package:user_app/features/due_payment/presentation/screens/due_payment_view_screen.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_action.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_edit.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_cell.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_table_header.dart';

class DuePaymentTable extends StatelessWidget {
  final List<DueUserModel> users;

  const DuePaymentTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final dueUserController = DueUserController();

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final user = users[index];

          void openUserDuePage() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DuePaymentViewScreen(
                  userId: user.userId,
                  userName: user.name,
                ),
              ),
            );
          }

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: openUserDuePage,
              borderRadius: BorderRadius.circular(14),

              hoverColor: AppColors.lightBlue.withOpacity(0.06),
              splashColor: AppColors.lightBlue.withOpacity(0.08),
              highlightColor: AppColors.lightBlue.withOpacity(0.04),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),

                width: DuePaymentTableHeader.tableMinWidth,

                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.lightBlue.withOpacity(0.05),
                      AppColors.mediumBlue.withOpacity(0.025),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    DuePaymentTableCell.text(user.name),

                    DuePaymentTableCell.text(user.phone),

                    DuePaymentTableCell.text(user.email),

                    DuePaymentTableCell.text(
                      "₹${user.balance.toStringAsFixed(2)}",
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
                            backgroundColor: AppColors.errorRed,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
