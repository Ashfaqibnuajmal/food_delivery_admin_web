import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/constants/admin_id.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/logic/provider/chat_provider.dart';
import 'package:user_app/features/chat/presentation/screens/chat_window.dart';

class ChatRightPanel extends StatelessWidget {
  final ChatController controller;

  const ChatRightPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<ChatListProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.pureWhite.withOpacity(0.05)),
          ),

          child: provider.selectedUserId == null
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/emptychat.webp',
                            width: width < 1100 ? 170 : 240,
                            height: width < 1100 ? 170 : 240,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "It's nice to chat with someone",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: width < 1100 ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Text(
                            "Pick a person from the left menu and start your conversation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.pureWhite.withOpacity(0.65),
                              fontSize: width < 1100 ? 13 : 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ChatWindow(
                    key: ValueKey(provider.selectedUserId),
                    userName: provider.selectedUserName!,
                    userId: provider.selectedUserId!,
                    adminId: adminId,
                    controller: controller,
                  ),
                ),
        );
      },
    );
  }
}
