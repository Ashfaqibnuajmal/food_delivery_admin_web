import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class ChatWindowHeader extends StatelessWidget {
  final String userName;
  final String? imageUrl;

  const ChatWindowHeader({super.key, required this.userName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// 👤 PROFILE IMAGE / INITIAL
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!)
                : null,
            child: (imageUrl == null || imageUrl!.isEmpty)
                ? (userName.isNotEmpty
                      ? Text(
                          userName[0].toUpperCase(),
                          style: CustomTextStyles.blueBig,
                        )
                      : const Icon(Icons.person, color: Colors.black, size: 22))
                : null,
          ),

          const SizedBox(width: 12),

          /// 🧑 USER NAME
          Expanded(
            child: Text(
              userName,
              style: CustomTextStyles.deleteTitle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
