// import 'package:flutter/material.dart';
// import 'package:user_app/core/theme/textstyle.dart';
// import 'package:user_app/core/widgets/input_decoration.dart'; // adjust path

// class CustomInputField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final TextInputType keyboard;
//   final int maxLines;
//   final bool isRequired; // for required validation
//   final Function(String)? onChanged;

//   const CustomInputField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.keyboard = TextInputType.text,
//     this.maxLines = 1,
//     this.isRequired = true,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboard,
//       maxLines: maxLines,
//       style: CustomTextStyles.text,
//       decoration: inputDecoration(label),

//       validator: (value) {
//         if (isRequired && (value == null || value.trim().isEmpty)) {
//           return "Enter $label";
//         }
//         return null;
//       },

//       onChanged: onChanged,
//     );
//   }
// }
