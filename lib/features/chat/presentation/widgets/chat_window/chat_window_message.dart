import 'package:flutter/material.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/data/model/chat_message_model.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import '../chat_list/message_bubble.dart';

class ChatWindowMessages extends StatelessWidget {
  final String userId;
  final String adminId;
  final ChatController controller;
  final ChatServices chatService;

  const ChatWindowMessages({
    super.key,
    required this.userId,
    required this.adminId,
    required this.controller,
    required this.chatService,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ChatMessageModel>>(
        stream: chatService.fetchMessages(userId),
        builder: (context, snapshot) {
          /// 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          /// ❌ Empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No messages yet",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          final messages = snapshot.data!;

          /// ✅ Auto scroll
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.scrollToBottom();
          });

          return ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isAdmin = msg.senderId == adminId;
              final timeStr = controller.formatMessageTime(msg.timestamp);

              return GestureDetector(
                onDoubleTap: () => controller.showDeleteDialog(
                  context: context,
                  chatService: chatService,
                  chatId: userId,
                  messageDocId: msg.docId,
                  messageText: msg.message,
                ),
                child: MessageBubble(
                  isMe: isAdmin,
                  message: msg.message,
                  time: timeStr,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
