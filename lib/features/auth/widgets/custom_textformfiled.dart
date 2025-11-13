import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;

  const LoginTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.black,
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
