import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window/chat_input_feild.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window/chat_window_header.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window/chat_window_message.dart';

class ChatWindow extends StatelessWidget {
  final String userName;
  final String userId;
  final String adminId;
  final String? email;
  final String? imageUrl;
  final ChatController controller;

  const ChatWindow({
    super.key,
    required this.userName,
    required this.userId,
    required this.adminId,
    required this.controller,
    this.email,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final chatService = context.read<ChatServices>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatService.markChatAsReadByAdmin(chatId: userId, adminId: adminId);
    });

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/chatbackgroundimage.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            ChatWindowHeader(userName: userName, imageUrl: imageUrl),
            ChatWindowMessages(
              userId: userId,
              adminId: adminId,
              controller: controller,
              chatService: chatService,
            ),
            ChatInputField(
              controller: controller.messageController,
              onSend: () => controller.sendMessage(
                chatService: chatService,
                chatId: userId,
                senderId: adminId,
                receiverId: userId,
                userName: userName,
                imageUrl: imageUrl,
                email: email,
                isAdminSender: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
