import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;       // true = admin message (right side)
  final String message;
  final String time;

  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    this.time = "",
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.45,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mediumBlue : AppColors.deepBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(14),
            bottomRight: const Radius.circular(14),
            topLeft: isMe ? const Radius.circular(14) : Radius.zero,
            topRight: isMe ? Radius.zero : const Radius.circular(14),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 14,
              ),
            ),
            if (time.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: AppColors.pureWhite.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
