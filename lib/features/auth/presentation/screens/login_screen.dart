import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/auth/provider/login_provider.dart';
import 'package:user_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:user_app/features/auth/presentation/widgets/custom_logo.dart';
import 'package:user_app/features/auth/presentation/widgets/custom_textformfiled.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context, listen: false);

    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 1,
            child: LoginLogoSection(
              logoPath: "assets/Logo.jpeg",
              title: "Admin",
              subtitle: "Manage your hotel efficiently",
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.deepBlue,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Admin Login",
                          style: CustomTextStyles.loginHeading,
                        ),
                        const SizedBox(height: 30),

                        LoginTextField(
                          hintText: "Enter your name",
                          icon: Icons.person,
                          controller: controller.nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        LoginTextField(
                          hintText: "Enter your password",
                          icon: Icons.lock,
                          controller: controller.passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        LoginButton(
                          label: "Login",
                          onPressed: () => controller.login(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
