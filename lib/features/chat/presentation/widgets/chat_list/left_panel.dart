import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/chat/data/model/chat_user_model.dart';
import 'package:user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:user_app/features/chat/data/services/chat_services.dart';
import 'package:user_app/features/chat/presentation/widgets/chat_list/user_chat_tile.dart';
import 'package:user_app/features/chat/logic/provider/chat_provider.dart';

class ChatLeftPanel extends StatelessWidget {
  final ChatServices chatService;
  final ChatController utils;

  const ChatLeftPanel({
    super.key,
    required this.chatService,
    required this.utils,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text("Chats", style: CustomTextStyles.title),
          ),

          /// 🔹 CHAT LIST
          Expanded(
            child: StreamBuilder<List<ChatUserModel>>(
              stream: chatService.fetchAllChatsForAdmin(),
              builder: (context, snapshot) {
                /// 🔄 LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.pureWhite,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(color: AppColors.pureWhite),
                    ),
                  );
                }

                /// ❌ EMPTY
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

                    final chatUserId = chat.userId;
                    final userName = chat.userName;
                    final lastMessage = chat.lastMessage;
                    final unread = chat.unreadByAdmin;

                    final timeStr = utils.formatTime(chat.lastMessageTime);

                    return Consumer<ChatListProvider>(
                      builder: (context, provider, child) {
                        final isSelected =
                            provider.selectedUserId == chatUserId;

                        return Container(
                          color: isSelected
                              ? AppColors.mediumBlue
                              : Colors.transparent,
                          child: UserChatTile(
                            name: userName,
                            message: lastMessage,
                            time: timeStr,
                            unread: unread,
                            imageUrl: chat.imageUrl,
                            onTap: () {
                              provider.selectUser(chatUserId, userName);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
