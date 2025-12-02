import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'message_bubble.dart';

class ChatWindow extends StatefulWidget {
  final String userName;
  final String userId; // <-- for chatId
  final String adminId; // <-- your admin id
  final String? imageUrl;

  const ChatWindow({
    super.key,
    required this.userName,
    required this.userId,
    required this.adminId,
    this.imageUrl,
  });

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _messageController = TextEditingController();
  late String chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.userId; // CHAT ID = USER ID (your current logic)
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatServices>(context, listen: false);

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
            // TOP BAR
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                        ? NetworkImage(widget.imageUrl!)
                        : null,
                    child: (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                        ? Text(
                            widget.userName[0].toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.darkBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // LIVE CHAT MESSAGES
            Expanded(
              child: StreamBuilder(
                stream: chatService.fetchMessages(chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final messages = snapshot.data!;

                  return ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      /// STATIC USER MESSAGE (your requirement)
                      const MessageBubble(
                        isMe: false,
                        message: "Hello, good morning 👋",
                      ),

                      /// REAL-TIME ADMIN MESSAGES FROM FIRESTORE
                      ...messages.map(
                        (msg) => MessageBubble(
                          isMe: msg.senderId == widget.adminId,
                          message: msg.message,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // INPUT AND SEND
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.deepBlue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      style: const TextStyle(color: AppColors.pureWhite),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(
                          color: AppColors.pureWhite.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: AppColors.mediumBlue,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: () async {
                      if (_messageController.text.trim().isEmpty) return;

                      await chatService.sendMessage(
                        chatId: chatId,
                        senderId: widget.adminId,
                        receiverId: widget.userId,
                        message: _messageController.text.trim(),
                      );

                      _messageController.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.mediumBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.pureWhite,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
