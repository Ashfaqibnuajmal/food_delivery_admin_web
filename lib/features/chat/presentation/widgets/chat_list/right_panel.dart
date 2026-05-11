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
    return Consumer<ChatListProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: provider.selectedUserId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/emptychat.webp',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "It's nice to chat with someone",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Pick a person from the left menu and start your conversation",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ChatWindow(
                  key: ValueKey(provider.selectedUserId),
                  userName: provider.selectedUserName!,
                  userId: provider.selectedUserId!,
                  adminId: adminId,
                  controller: controller,
                ),
        );
      },
    );
  }
}
