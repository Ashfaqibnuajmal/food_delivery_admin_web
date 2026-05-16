import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/logic/controller/due_user_controller.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_payment_screen/due_payment_dialog_button.dart';
import 'package:user_app/features/due_payment/logic/provider/due_user_action_provider.dart';

Future<void> customEditDuePaymentDialog({
  required BuildContext context,
  required DueUserModel currentUser,
}) async {
  final screenContext = context;

  return showDialog(
    context: screenContext,
    builder: (dialogContext) {
      return EditDuePaymentDialog(
        currentUser: currentUser,
        screenContext: screenContext,
      );
    },
  );
}

class EditDuePaymentDialog extends StatefulWidget {
  final DueUserModel currentUser;
  final BuildContext screenContext;

  const EditDuePaymentDialog({
    super.key,
    required this.currentUser,
    required this.screenContext,
  });

  @override
  State<EditDuePaymentDialog> createState() => _EditDuePaymentDialogState();
}

class _EditDuePaymentDialogState extends State<EditDuePaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dueUserController = DueUserController();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.currentUser.name);
    _phoneController = TextEditingController(text: widget.currentUser.phone);
    _emailController = TextEditingController(text: widget.currentUser.email);
  }

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
                  child: Text("Edit Due User", style: CustomTextStyles.title),
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
                        label: "Update",
                        isLoading: actionProvider.isSavingUser,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          actionProvider.runUserAction(() {
                            return _dueUserController.updateUser(
                              dialogContext: context,
                              screenContext: widget.screenContext,
                              formKey: _formKey,
                              currentUser: widget.currentUser,
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
