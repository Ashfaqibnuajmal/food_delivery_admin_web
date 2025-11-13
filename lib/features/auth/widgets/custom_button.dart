import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBlue,
        foregroundColor: AppColors.pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
