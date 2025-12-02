import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class ChatSearchbar extends StatelessWidget {
  const ChatSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.pureWhite),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: const InputDecoration(
                hintText: "Search user...",
                hintStyle: TextStyle(color: AppColors.pureWhite),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
