import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due payment/data/model/due_user_model.dart';
import 'package:user_app/features/due payment/data/services/due_payment_services.dart';
import 'package:user_app/core/widgets/input_decoration.dart';

Future<void> customEditDuePaymentDialog({
  required BuildContext context,
  required DueUserModel currentUser,
}) async {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: currentUser.name);
  final phoneController = TextEditingController(text: currentUser.phone);
  final emailController = TextEditingController(text: currentUser.email);

  final duePaymentService = DuePaymentService();

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
                      "Edit Due Payment User",
                      style: CustomTextStyles.title,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Name
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: inputDecoration("Name"),
                    validator: (value) => validator(value, "Name"),
                    style: CustomTextStyles.text,
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration("Phone number"),
                    validator: (value) => validator(value, "Phone number"),
                    style: CustomTextStyles.text,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration("Email"),
                    validator: (value) => validator(value, "Email"),
                    style: CustomTextStyles.text,
                  ),
                  const SizedBox(height: 30),

                  // Update button
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
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return; // ❌ validations failed
                        }

                        final updatedUser = DueUserModel(
                          userId: currentUser.userId,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                          balance: currentUser.balance,
                        );

                        try {
                          await duePaymentService.editDueUser(updatedUser);
                          log("✅ User updated: ${updatedUser.name}");
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          log("❌ Error editing user: $e");
                        }
                      },
                      child: const Text(
                        "Update",
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
