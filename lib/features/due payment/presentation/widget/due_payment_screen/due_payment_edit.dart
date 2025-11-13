import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/due%20payment/data/model/due_user_model.dart';
import 'package:user_app/features/due%20payment/data/services/due_payment_services.dart';

Future<void> customEditDuePaymentDialog({
  required BuildContext context,
  required DueUserModel currentUser,
}) async {
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
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: inputDecoration("Name"),
                  style: CustomTextStyles.text,
                ),
                const SizedBox(height: 20),

                // Phone
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration("Phone number"),
                  style: CustomTextStyles.text,
                ),
                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration("Email"),
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
                      final updatedName = nameController.text.trim();
                      final updatedPhone = phoneController.text.trim();
                      final updatedEmail = emailController.text.trim();

                      if (updatedName.isEmpty ||
                          updatedPhone.isEmpty ||
                          updatedEmail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("All fields are required"),
                          ),
                        );
                        return;
                      }

                      final updatedUser = DueUserModel(
                        userId: currentUser.userId,
                        name: updatedName,
                        phone: updatedPhone,
                        email: updatedEmail,
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
      );
    },
  );
}

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: AppColors.darkBlue,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
