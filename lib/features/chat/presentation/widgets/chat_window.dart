import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'message_bubble.dart';

class ChatWindow extends StatefulWidget {
  final String userName;
  final String? imageUrl;

  const ChatWindow({super.key, required this.userName, this.imageUrl});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            "assets/chatbackgroundimage.jpg",
            fit: BoxFit.cover,
          ),
        ),

        /// CHAT UI LAYER
        Column(
          children: [
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

            // CHAT MESSAGES LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: const [
                  MessageBubble(isMe: false, message: "Hello, good morning 👋"),
                  MessageBubble(
                    isMe: true,
                    message: "Hi, good morning! How can I help you today?",
                  ),
                ],
              ),
            ),

            // MESSAGE INPUT FIELD + SEND BUTTON
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
                    onTap: () {
                      if (_messageController.text.trim().isEmpty) return;

                      // STATIC ACTION NOW — Firebase later
                      debugPrint("Message Sent => ${_messageController.text}");

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
