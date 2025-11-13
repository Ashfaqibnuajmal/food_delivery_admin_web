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

    // Keep cursor at the end when voice sets new text
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

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
              controller: controller,
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(color: AppColors.pureWhite),
                border: InputBorder.none,
              ),
              onChanged: provider.updateQuery,
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(
                provider.isListening ? Icons.mic : Icons.mic_none,
                color: provider.isListening
                    ? Colors.redAccent
                    : AppColors.pureWhite,
              ),
              onPressed: provider.toggleVoiceListening,
            ),
          ),
        ],
      ),
    );
  }
}
