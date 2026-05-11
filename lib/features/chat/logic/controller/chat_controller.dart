import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window/chat_delete_dilog.dart';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String formatTime(dynamic timestamp) {
    if (timestamp == null) return "";

    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      final now = DateTime.now();

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return formatMessageTime(date);
      }

      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
    }

    return "";
  }

  String formatMessageTime(DateTime? timestamp) {
    if (timestamp == null) return "";

    final hour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);

    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';

    return "${hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} $amPm";
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendMessage({
    required ChatServices chatService,
    required String chatId,
    required String senderId,
    required String receiverId,
    String? userName,
    String? imageUrl,
    String? email,
    required bool isAdminSender,
  }) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    await chatService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: text,
      userName: userName,
      imageUrl: imageUrl,
      email: email,
      isAdminSender: isAdminSender,
    );

    scrollToBottom();
  }

  void showDeleteDialog({
    required BuildContext context,
    required ChatServices chatService,
    required String chatId,
    required String messageDocId,
    required String messageText,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return ChatDeleteDialog(
          messageText: messageText,
          onConfirm: () async {
            await chatService.deleteMessage(
              chatId: chatId,
              messageDocId: messageDocId,
            );
          },
        );
      },
    );
  }

  void dispose() {
    messageController.dispose();
    scrollController.dispose();
  }
}
