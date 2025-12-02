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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Flexible(
              flex: 2, // left side small
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
                        "All Users",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Expanded(
                      child: StreamBuilder(
                        stream: _chatService.getAllUsers(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.pureWhite,
                              ),
                            );
                          }

                          final users = snapshot.data!;

                          if (users.isEmpty) {
                            return const Center(
                              child: Text(
                                "No users found",
                                style: TextStyle(color: AppColors.pureWhite),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return UserChatTile(
                                name: user['name'] ?? "",
                                message: "Start chat with ${user['name']}",
                                time: "",
                                unread: 0,
                                imageUrl: (user['imageUrl'] ?? "").toString(),
                                onTap: () {
                                  setState(() {
                                    selectedUserId = user['id'];
                                    selectedUserName = user['name'];
                                  });
                                },
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

            Flexible(
              flex: 2, // big chat window
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
                            // Image for empty chat
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
                            // Main title
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
                            // Subtitle
                            const Text(
                              "Pick a person from the left menu and start your conversation",
                              style: TextStyle(
                                color: AppColors.pureWhite, // lighter white
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ChatWindow(
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
