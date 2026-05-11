import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/web_color.dart';

class VoiceSearchBar extends StatelessWidget {
  const VoiceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserSearchProvider>();

    final controller = TextEditingController(text: provider.query);

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          // SEARCH ICON
          const Icon(Icons.search, color: AppColors.lightBlue, size: 25),

          const SizedBox(width: 12),

          // TEXTFIELD
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: AppColors.lightBlue,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(
                  color: AppColors.pureWhite.withOpacity(0.45),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
              onChanged: provider.updateQuery,
            ),
          ),

          const SizedBox(width: 10),

          // MIC BUTTON
          GestureDetector(
            onTap: provider.toggleVoiceListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: provider.isListening
                    ? AppColors.lightBlue
                    : AppColors.darkBlue.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue.withOpacity(0.12),
                ),
              ),
              child: Icon(
                provider.isListening ? Icons.mic : Icons.mic_none_rounded,
                color: provider.isListening
                    ? AppColors.darkBlue
                    : AppColors.lightBlue,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
