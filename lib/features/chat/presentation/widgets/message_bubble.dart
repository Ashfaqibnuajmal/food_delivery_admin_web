import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const MessageBubble({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mediumBlue : AppColors.deepBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.pureWhite),
        ),
      ),
    );
  }
}
