import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/chat/data/model/chat_message_model.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'message_bubble.dart';

class ChatWindow extends StatefulWidget {
  final String userName;
  final String userId; // = chatId (one chat doc per user)
  final String adminId;
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when admin opens this chat
    final chatService = Provider.of<ChatServices>(context, listen: false);
    chatService.markChatAsReadByAdmin(widget.userId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Auto-scroll to the bottom of the message list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
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
            // ── TOP BAR ──
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
                    child:
                        (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                            ? Text(
                                widget.userName.isNotEmpty
                                    ? widget.userName[0].toUpperCase()
                                    : '?',
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

            // ── LIVE CHAT MESSAGES ──
            Expanded(
              child: StreamBuilder<List<ChatMessageModel>>(
                stream: chatService.fetchMessages(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  final messages = snapshot.data!;

                  // Auto-scroll when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isAdmin = msg.senderId == widget.adminId;

                      // Format timestamp
                      String timeStr = "";
                      if (msg.timestamp != null) {
                        final t = msg.timestamp!;
                        timeStr =
                            "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                      }

                      return MessageBubble(
                        isMe: isAdmin,  // Admin's messages on the right
                        message: msg.message,
                        time: timeStr,
                      );
                    },
                  );
                },
              ),
            ),

            // ── INPUT AND SEND ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (_) => _sendMessage(chatService),
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
                    onTap: () => _sendMessage(chatService),
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

  /// Send message from admin
  Future<void> _sendMessage(ChatServices chatService) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    await chatService.sendMessage(
      chatId: widget.userId,      // Chat doc = user's ID
      senderId: widget.adminId,   // Sender is admin
      receiverId: widget.userId,  // Receiver is the user
      message: text,
    );

    _scrollToBottom();
  }
}
