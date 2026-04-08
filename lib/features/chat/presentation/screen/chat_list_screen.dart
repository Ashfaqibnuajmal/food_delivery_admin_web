import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/constants/admin_id.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_searchbar.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_window.dart';
import 'package:user_app/features/chat/presentation/widgets/user_chat_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatServices _chatService = ChatServices();

  String? selectedUserId;
  String? selectedUserName;

  /// Format the Firestore timestamp for display in the chat tile
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return "";
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      final now = DateTime.now();
      // If today, show time. Otherwise show date.
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
        final amPm = date.hour >= 12 ? 'PM' : 'AM';
        return "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm";
      } else {
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // ── LEFT PANEL: List of active chats ──
            Flexible(
              flex: 2,
              child: Container(
                color: AppColors.darkBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: ChatSearchbar(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 12),
                      child: Text(
                        "Chats",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // ✅ FIX: Stream from "Chats" collection (only users who messaged)
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _chatService.fetchAllChatsForAdmin(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.pureWhite,
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                "No chats yet",
                                style: TextStyle(color: AppColors.pureWhite),
                              ),
                            );
                          }

                          final chats = snapshot.data!;

                          return ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              final chat = chats[index];
                              final chatUserId =
                                  chat['userId']?.toString() ?? '';
                              final userName =
                                  chat['userName']?.toString() ?? 'User';
                              final lastMessage =
                                  chat['lastMessage']?.toString() ?? '';
                              final unread =
                                  (chat['unreadByAdmin'] as num?)?.toInt() ?? 0;
                              final timeStr =
                                  _formatTime(chat['lastMessageTime']);

                              final isSelected =
                                  selectedUserId == chatUserId;

                              return Container(
                                color: isSelected
                                    ? AppColors.mediumBlue
                                    : Colors.transparent,
                                child: UserChatTile(
                                  name: userName,
                                  message: lastMessage,
                                  time: timeStr,
                                  unread: unread,
                                  imageUrl:
                                      (chat['imageUrl'] ?? "").toString(),
                                  onTap: () {
                                    setState(() {
                                      selectedUserId = chatUserId;
                                      selectedUserName = userName;
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── RIGHT PANEL: Chat window ──
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: selectedUserId == null
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
                        key: ValueKey(selectedUserId),  // ✅ Forces rebuild on user switch
                        userName: selectedUserName!,
                        userId: selectedUserId!,
                        adminId: adminId,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
