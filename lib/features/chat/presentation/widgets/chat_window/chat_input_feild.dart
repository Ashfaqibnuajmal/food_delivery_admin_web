import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// ✍️ TEXT FIELD
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: AppColors.pureWhite),
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(
                  color: AppColors.pureWhite.withOpacity(0.7),
                ),
                filled: true,
                fillColor: AppColors.mediumBlue,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// 📤 SEND BUTTON
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.mediumBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: AppColors.pureWhite,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
