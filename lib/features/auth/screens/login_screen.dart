import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/auth/widgets/custom_button.dart';
import 'package:user_app/features/auth/widgets/custom_logo.dart';
import 'package:user_app/features/auth/widgets/custom_textformfiled.dart';
import 'package:user_app/features/home/home.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    const String validName = "a";
    const String validPassword = "2";

    if (_formKey.currentState!.validate()) {
      if (_nameController.text == validName &&
          _passwordController.text == validPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid username or password",
              style: CustomTextStyles.snackBar,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Logo Section
          const Expanded(
            flex: 1,
            child: LoginLogoSection(
              logoPath: "assets/Logo.jpeg",
              title: "Admin",
              subtitle: "Manage your hotel efficiently",
            ),
          ),

          // Right Login Form
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.deepBlue, // themed background
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Admin Login",
                          style: CustomTextStyles.loginHeading,
                        ),
                        const SizedBox(height: 30),

                        // Name field
                        LoginTextField(
                          hintText: "Enter your name",
                          icon: Icons.person,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        LoginTextField(
                          hintText: "Enter your password",
                          icon: Icons.lock,
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Login button
                        LoginButton(
                          label: "Login",
                          onPressed: () => _login(context),
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
