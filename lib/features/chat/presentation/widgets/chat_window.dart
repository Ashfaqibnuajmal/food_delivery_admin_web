import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart' show AppColors;

class ChatWindow extends StatelessWidget {
  final String userName;
  final String? imageUrl;

  const ChatWindow({super.key, required this.userName, this.imageUrl});

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

        // Positioned.fill(child: Container(color: AppColors.)),

        /// CHAT UI LAYER
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
                    backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? NetworkImage(imageUrl!)
                        : null,
                    child: (imageUrl == null || imageUrl!.isEmpty)
                        ? Text(
                            userName[0].toUpperCase(),
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
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: const [
                  Text(
                    "Chat UI Ready...",
                    style: TextStyle(color: Colors.white),
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
