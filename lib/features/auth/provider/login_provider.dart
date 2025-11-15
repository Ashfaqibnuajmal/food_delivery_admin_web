import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/features/home/home.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final String validName = "a";
  final String validPassword = "2";

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (nameController.text == validName &&
          passwordController.text == validPassword) {
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
}
