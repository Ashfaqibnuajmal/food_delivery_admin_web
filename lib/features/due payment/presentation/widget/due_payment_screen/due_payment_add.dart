import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due%20payment/controller/due_user_controller.dart';

Future<void> customAddDuePaymentDialog({required BuildContext context}) async {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add Due Payment User",
                      style: CustomTextStyles.title,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Name
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: inputDecoration("Name"),
                    style: CustomTextStyles.text,
                    validator: (value) =>
                        DueUserController.validator(value, "name"),
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration("Phone number"),
                    style: CustomTextStyles.text,
                    validator: (value) =>
                        DueUserController.validator(value, "phone number"),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration("Email"),
                    style: CustomTextStyles.text,
                    validator: (value) =>
                        DueUserController.validator(value, "email"),
                  ),
                  const SizedBox(height: 30),

                  // Add button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        DueUserController.handleAddUser(
                          context: context,
                          formKey: formKey,
                          nameController: nameController,
                          phoneController: phoneController,
                          emailController: emailController,
                        );
                      },
                      child: const Text(
                        "Add User",
                        style: CustomTextStyles.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
