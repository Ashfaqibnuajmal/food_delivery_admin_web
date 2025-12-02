import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? selectedUserId;

  final List<Map<String, dynamic>> _dummyChats = const [
    {
      'id': '1',
      'name': 'Sabna',
      'message': "Hello admin, is my order ready?",
      'time': '10:24 AM',
      'unread': 2,
      'imageUrl':
          "https://res.cloudinary.com/dsuwmcmw4/image/upload/v1762450141/nkpx6oyofbb0rsdxft5j.jpg",
    },
    {
      'id': '2',
      'name': 'Ashfaq',
      'message': "I'm waiting for confirmation.",
      'time': 'Yesterday',
      'unread': 0,
      'imageUrl': "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // =======================
            // CHAT LIST SECTION (25%)
            // =======================
            Flexible(
              flex: 2, // 25%
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
                      child: _SearchBar(),
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
                      child: ListView.builder(
                        itemCount: _dummyChats.length,
                        itemBuilder: (context, index) {
                          final chat = _dummyChats[index];
                          return _UserChatTile(
                            name: chat['name'],
                            message: chat['message'],
                            time: chat['time'],
                            unread: chat['unread'],
                            imageUrl: chat['imageUrl'],
                            onTap: () {
                              setState(() {
                                selectedUserId = chat['id'];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =======================
            // CHAT WINDOW SECTION (75%)
            // =======================
            Flexible(
              flex: 2, // 75%
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.mediumBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: selectedUserId == null
                    ? const Center(
                        child: Text(
                          "Select a user to start chat",
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : _ChatWindow(userName: _getUserName()),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getUserName() {
    return _dummyChats
        .firstWhere((chat) => chat['id'] == selectedUserId)['name']
        .toString();
  }
}

// ============================
// CHAT WINDOW
// ============================
class _ChatWindow extends StatelessWidget {
  final String userName;
  const _ChatWindow({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TITLE BAR
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Text(
            userName,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // MESSAGES
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: const [
              _MessageBubble(isMe: false, message: "Hello Admin 👋"),
              _MessageBubble(isMe: true, message: "Yes, how can I help you?"),
            ],
          ),
        ),

        // MESSAGE INPUT
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: AppColors.pureWhite),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: AppColors.pureWhite),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Icon(Icons.send, color: AppColors.pureWhite),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================
// MESSAGE BUBBLE
// ============================
class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const _MessageBubble({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mediumBlue : AppColors.deepBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.pureWhite),
        ),
      ),
    );
  }
}

// ============================
// SEARCH BAR
// ============================
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.pureWhite),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: const InputDecoration(
                hintText: "Search user...",
                hintStyle: TextStyle(color: AppColors.pureWhite),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================
// USER CHAT TILE
// ============================
class _UserChatTile extends StatelessWidget {
  final String name, message, time, imageUrl;
  final int unread;
  final VoidCallback? onTap;

  const _UserChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.unread,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: AppColors.mediumBlue,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.mediumBlue,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: AppColors.pureWhite.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.pureWhite.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mediumBlue.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unread.toString(),
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
