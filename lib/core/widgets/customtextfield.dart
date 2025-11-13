import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

// ignore: must_be_immutable
class CustemTextFIeld extends StatefulWidget {
  final TextInputType textType;
  final String hintText;
  final TextEditingController controller;
  final bool password;
  final bool readOnly;
  final bool enabled;
  String? Function(String?)? validator;
  VoidCallback? ontap;

  CustemTextFIeld({
    super.key,
    this.enabled = true,
    this.ontap,
    this.textType = TextInputType.text,
    required this.hintText,
    required this.controller,
    this.password = false,
    this.readOnly = false,
    this.validator,
  });

  @override
  State<CustemTextFIeld> createState() => _CustemTextFIeldState();
}

class _CustemTextFIeldState extends State<CustemTextFIeld> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextFormField(
          enabled: widget.enabled,
          keyboardType: widget.textType,
          validator: widget.validator,
          readOnly: widget.readOnly,
          controller: widget.controller,
          obscureText: _obscureText,
          onTap: widget.ontap,
          style: const TextStyle(color: AppColors.pureWhite),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: AppColors.darkBlue,
            suffixIcon: widget.password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.lightBlue,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.lightBlue,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
