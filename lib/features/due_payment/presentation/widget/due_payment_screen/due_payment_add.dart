import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due_payment/logic/controller/due_user_controller.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_dialog_button.dart';
import 'package:user_app/features/due_payment/logic/provider/due_user_action_provider.dart';

Future<void> customAddDuePaymentDialog({required BuildContext context}) async {
  final screenContext = context;

  return showDialog(
    context: screenContext,
    builder: (dialogContext) {
      return AddDuePaymentDialog(screenContext: screenContext);
    },
  );
}

class AddDuePaymentDialog extends StatefulWidget {
  final BuildContext screenContext;

  const AddDuePaymentDialog({super.key, required this.screenContext});

  @override
  State<AddDuePaymentDialog> createState() => _AddDuePaymentDialogState();
}

class _AddDuePaymentDialogState extends State<AddDuePaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dueUserController = DueUserController();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
      child: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Add Due User", style: CustomTextStyles.title),
                ),
                const SizedBox(height: 25),

                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: inputDecoration("Name"),
                  style: CustomTextStyles.text,
                  validator: _dueUserController.validateName,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration("Phone number"),
                  style: CustomTextStyles.text,
                  validator: _dueUserController.validatePhone,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration("Email"),
                  style: CustomTextStyles.text,
                  validator: _dueUserController.validateEmail,
                ),
                const SizedBox(height: 30),

                Center(
                  child: Consumer<DueUserActionProvider>(
                    builder: (context, actionProvider, _) {
                      return DuePaymentDialogButton(
                        label: "Add User",
                        isLoading: actionProvider.isSavingUser,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          actionProvider.runUserAction(() {
                            return _dueUserController.addUser(
                              dialogContext: context,
                              screenContext: widget.screenContext,
                              formKey: _formKey,
                              nameController: _nameController,
                              phoneController: _phoneController,
                              emailController: _emailController,
                            );
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
      ),
    );
  }
}
